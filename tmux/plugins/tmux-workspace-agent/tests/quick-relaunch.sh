#!/usr/bin/env bash

set -euo pipefail

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(cd "$CURRENT_DIR/.." && pwd)"
LAUNCHER_SCRIPT="$PLUGIN_DIR/scripts/launch-menu.sh"
QUICK_RELAUNCH_SCRIPT="$PLUGIN_DIR/scripts/quick-relaunch.sh"
TMUX_CONF="/Users/ict/.config/tmux/tmux.conf"
SOCKET="workspace-agent-quick-relaunch-$$"

TMP_ROOT="$(mktemp -d "/tmp/workspace-agent-quick-relaunch.XXXXXX")"
BIN_DIR="$TMP_ROOT/bin"
EMPTY_BIN_DIR="$TMP_ROOT/empty-bin"
LOG_FILE="$TMP_ROOT/agent-launch.log"
STATE_HOME="$TMP_ROOT/state"
mkdir -p "$BIN_DIR" "$EMPTY_BIN_DIR" "$STATE_HOME"
touch "$LOG_FILE"

cleanup() {
	tmux -L "$SOCKET" kill-server >/dev/null 2>&1 || true
	rm -rf "$TMP_ROOT"
}

trap cleanup EXIT

assert_equals() {
	local expected="$1"
	local actual="$2"
	local message="$3"

	if [ "$expected" != "$actual" ]; then
		printf '%s: expected [%s], got [%s]\n' "$message" "$expected" "$actual" >&2
		exit 1
	fi
}

wait_for_log_lines() {
	local expected_count="$1"
	local attempts=40
	local current_count=0

	while [ "$attempts" -gt 0 ]; do
		current_count="$(wc -l <"$LOG_FILE" | tr -d ' ')"
		if [ "$current_count" -ge "$expected_count" ]; then
			return 0
		fi
		attempts=$((attempts - 1))
		sleep 0.1
	done

	printf 'timed out waiting for %s log lines (have %s)\n' "$expected_count" "$current_count" >&2
	exit 1
}

latest_log_line() {
	awk 'END { print }' "$LOG_FILE"
}

read_state_env() {
	local state_file="$1"
	bash -c 'set -euo pipefail; source "$1"; printf "%s|%s|%s|%s" "${last_agent:-}" "${last_workspace:-}" "${last_status:-}" "${last_path:-}"' _ "$state_file"
}

install_stub_agent() {
	local agent="$1"
	cat >"$BIN_DIR/$agent" <<EOF
#!/usr/bin/env bash
printf '%s|%s\n' "$agent" "\$PWD" >> "$LOG_FILE"
EOF
	chmod +x "$BIN_DIR/$agent"
}

install_stub_agent "opencode"

tmux -L "$SOCKET" -f "$TMUX_CONF" new-session -d -s quickw1
tmux -L "$SOCKET" source-file "$TMUX_CONF"
tmux -L "$SOCKET" new-session -d -s quickw2

socket_path="$(tmux -L "$SOCKET" display-message -p -t quickw1:1.1 '#{socket_path}')"
pane_w1="$(tmux -S "$socket_path" display-message -p -t quickw1:1.1 '#{pane_id}')"
pane_w2="$(tmux -S "$socket_path" display-message -p -t quickw2:1.1 '#{pane_id}')"
state_file="$STATE_HOME/tmux-workspace-agent/state.env"
tmux_bin_dir="$(dirname "$(command -v tmux)")"

line_count=0

w1_initial_path="$TMP_ROOT/w1-initial"
mkdir -p "$w1_initial_path"
PATH="$BIN_DIR:$PATH" XDG_STATE_HOME="$STATE_HOME" \
	"$LAUNCHER_SCRIPT" "$socket_path" "$pane_w1" "$w1_initial_path" launch-agent "opencode"
line_count=$((line_count + 1))
wait_for_log_lines "$line_count"
assert_equals "opencode|$w1_initial_path" "$(latest_log_line)" "initial launch should use w1 path"

w1_relaunch_path="$TMP_ROOT/w1-relaunch"
mkdir -p "$w1_relaunch_path"
PATH="$BIN_DIR:$PATH" XDG_STATE_HOME="$STATE_HOME" \
	"$QUICK_RELAUNCH_SCRIPT" "$socket_path" "$pane_w1" "$w1_relaunch_path"
line_count=$((line_count + 1))
wait_for_log_lines "$line_count"
assert_equals "opencode|$w1_relaunch_path" "$(latest_log_line)" "quick relaunch should use latest caller path"

tmux -S "$socket_path" set-option -gu '@workspace_agent_last_agent'
rm -f "$state_file"
line_count_before_no_history="$(wc -l <"$LOG_FILE" | tr -d ' ')"
PATH="$BIN_DIR:$PATH" XDG_STATE_HOME="$STATE_HOME" \
	"$QUICK_RELAUNCH_SCRIPT" "$socket_path" "$pane_w1" "$TMP_ROOT/no-history-path"
line_count_after_no_history="$(wc -l <"$LOG_FILE" | tr -d ' ')"
assert_equals "$line_count_before_no_history" "$line_count_after_no_history" "no-history quick relaunch should not launch any process"

tmux -S "$socket_path" set-option -gq '@workspace_agent_clis' 'opencode,ghostagent'
tmux -S "$socket_path" set-option -gq '@workspace_agent_last_agent' 'ghostagent'
line_count_before_stale="$(wc -l <"$LOG_FILE" | tr -d ' ')"
PATH="$tmux_bin_dir:/usr/bin:/bin:$EMPTY_BIN_DIR" XDG_STATE_HOME="$STATE_HOME" \
	"$QUICK_RELAUNCH_SCRIPT" "$socket_path" "$pane_w1" "$TMP_ROOT/stale-history-path"
line_count_after_stale="$(wc -l <"$LOG_FILE" | tr -d ' ')"
assert_equals "$line_count_before_stale" "$line_count_after_stale" "stale-history quick relaunch should not launch any process"
assert_equals "ghostagent" "$(tmux -S "$socket_path" show-option -gqv '@workspace_agent_last_agent')" "stale-history should preserve last-agent state"

w1_recovery_launch_path="$TMP_ROOT/w1-recovery-launch"
mkdir -p "$w1_recovery_launch_path"
PATH="$BIN_DIR:$PATH" XDG_STATE_HOME="$STATE_HOME" \
	"$LAUNCHER_SCRIPT" "$socket_path" "$pane_w1" "$w1_recovery_launch_path" launch-agent "opencode"
line_count=$((line_count + 1))
wait_for_log_lines "$line_count"
assert_equals "opencode|$w1_recovery_launch_path" "$(latest_log_line)" "launch should recover after stale-history failure"

w1_recovery_relaunch_path="$TMP_ROOT/w1-recovery-relaunch"
mkdir -p "$w1_recovery_relaunch_path"
PATH="$BIN_DIR:$PATH" XDG_STATE_HOME="$STATE_HOME" \
	"$QUICK_RELAUNCH_SCRIPT" "$socket_path" "$pane_w1" "$w1_recovery_relaunch_path"
line_count=$((line_count + 1))
wait_for_log_lines "$line_count"
assert_equals "opencode|$w1_recovery_relaunch_path" "$(latest_log_line)" "quick relaunch should work after recovery launch"

w2_relaunch_path="$TMP_ROOT/w2-relaunch"
mkdir -p "$w2_relaunch_path"
PATH="$BIN_DIR:$PATH" XDG_STATE_HOME="$STATE_HOME" \
	"$QUICK_RELAUNCH_SCRIPT" "$socket_path" "$pane_w2" "$w2_relaunch_path"
line_count=$((line_count + 1))
wait_for_log_lines "$line_count"
assert_equals "opencode|$w2_relaunch_path" "$(latest_log_line)" "cross-workspace quick relaunch should use active workspace path"
assert_equals "opencode|quickw2|running|$w2_relaunch_path" "$(read_state_env "$state_file")" "state should follow active workspace after cross-workspace relaunch"

printf 'quick relaunch test passed\n'
