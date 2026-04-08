#!/usr/bin/env bash

set -euo pipefail

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(cd "$CURRENT_DIR/.." && pwd)"
LAUNCHER_SCRIPT="$PLUGIN_DIR/scripts/launch-menu.sh"
TMUX_CONF="/Users/ict/.config/tmux/tmux.conf"
SOCKET="workspace-agent-agent-picker-$$"

TMP_ROOT="$(mktemp -d "/tmp/workspace-agent-agent-picker.XXXXXX")"
BIN_DIR="$TMP_ROOT/bin"
LOG_FILE="$TMP_ROOT/agent-launch.log"
STATE_HOME="$TMP_ROOT/state"
PANE_ROOT="$TMP_ROOT/panes"
mkdir -p "$BIN_DIR" "$STATE_HOME" "$PANE_ROOT"
touch "$LOG_FILE"

cleanup() {
	tmux -L "$SOCKET" kill-server >/dev/null 2>&1 || true
	rm -rf "$TMP_ROOT"
}

trap cleanup EXIT

run_expect_fail() {
	if "$@"; then
		printf 'expected command to fail: %s\n' "$*" >&2
		exit 1
	fi
}

wait_for_log_lines() {
	local expected_count="$1"
	local attempts=40
	local current_count

	while [ "$attempts" -gt 0 ]; do
		current_count="$(wc -l <"$LOG_FILE" | tr -d ' ')"
		if [ "$current_count" -ge "$expected_count" ]; then
			return 0
		fi
		attempts=$((attempts - 1))
		sleep 0.1
	done

	printf 'timed out waiting for %s log lines (have %s)\n' "$expected_count" "${current_count:-0}" >&2
	exit 1
}

read_state_env() {
	local state_file="$1"
	bash -c 'set -euo pipefail; source "$1"; printf "%s|%s|%s|%s" "$last_agent" "${last_workspace:-}" "${last_status:-}" "${last_path:-}"' _ "$state_file"
}

latest_log_line() {
	tail -n 1 "$LOG_FILE"
}

assert_equals() {
	local expected="$1"
	local actual="$2"
	local message="$3"
	if [ "$expected" != "$actual" ]; then
		printf '%s: expected [%s], got [%s]\n' "$message" "$expected" "$actual" >&2
		exit 1
	fi
}

install_stub_agent() {
	local agent="$1"
	cat >"$BIN_DIR/$agent" <<EOF
#!/usr/bin/env bash
printf '%s|%s\n' "$agent" "\$PWD" >> "$LOG_FILE"
EOF
	chmod +x "$BIN_DIR/$agent"
}

for agent in opencode codex droid pi; do
	install_stub_agent "$agent"
done

tmux -L "$SOCKET" -f "$TMUX_CONF" new-session -d -s agentpicker
tmux -L "$SOCKET" source-file "$TMUX_CONF"

socket_path="$(tmux -L "$SOCKET" display-message -p -t agentpicker:1.1 '#{socket_path}')"
pane_id="$(tmux -S "$socket_path" display-message -p -t agentpicker:1.1 '#{pane_id}')"
state_file="$STATE_HOME/tmux-workspace-agent/state.env"

line_count=0
for agent in opencode codex droid pi; do
	agent_path="$PANE_ROOT/$agent"
	mkdir -p "$agent_path"

	PATH="$BIN_DIR:$PATH" XDG_STATE_HOME="$STATE_HOME" \
		"$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$agent_path" launch-agent "$agent"

	line_count=$((line_count + 1))
	wait_for_log_lines "$line_count"
	assert_equals "$agent|$agent_path" "$(latest_log_line)" "agent launch path mismatch for $agent"
	assert_equals "$agent" "$(tmux -S "$socket_path" show-option -gqv '@workspace_agent_last_agent')" "last-agent tmux option mismatch for $agent"
	assert_equals "$agent|agentpicker|running|$agent_path" "$(read_state_env "$state_file")" "state file mismatch for $agent"
done

pane_context_before_cancel="$(tmux -S "$socket_path" display-message -p -t "$pane_id" '#{session_name}:#{window_index}.#{pane_index}')"
last_agent_before_cancel="$(tmux -S "$socket_path" show-option -gqv '@workspace_agent_last_agent')"
state_before_cancel="$(read_state_env "$state_file")"
line_count_before_cancel="$(wc -l <"$LOG_FILE" | tr -d ' ')"

PATH="$BIN_DIR:$PATH" XDG_STATE_HOME="$STATE_HOME" \
	"$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$PANE_ROOT/cancel" launch-agent ""

line_count_after_cancel="$(wc -l <"$LOG_FILE" | tr -d ' ')"
assert_equals "$line_count_before_cancel" "$line_count_after_cancel" "cancel should not launch any agent"
assert_equals "$last_agent_before_cancel" "$(tmux -S "$socket_path" show-option -gqv '@workspace_agent_last_agent')" "cancel should not mutate last-agent option"
assert_equals "$state_before_cancel" "$(read_state_env "$state_file")" "cancel should not mutate state file"
assert_equals "$pane_context_before_cancel" "$(tmux -S "$socket_path" display-message -p -t "$pane_id" '#{session_name}:#{window_index}.#{pane_index}')" "cancel should preserve pane context"

missing_agent="ghostagent"
tmux -S "$socket_path" set-option -gq '@workspace_agent_clis' 'opencode,codex,droid,pi,ghostagent'
line_count_before_missing="$(wc -l <"$LOG_FILE" | tr -d ' ')"
last_agent_before_missing="$(tmux -S "$socket_path" show-option -gqv '@workspace_agent_last_agent')"
state_before_missing="$(read_state_env "$state_file")"

run_expect_fail env PATH="$BIN_DIR:$PATH" XDG_STATE_HOME="$STATE_HOME" \
	"$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$PANE_ROOT/missing" launch-agent "$missing_agent"

line_count_after_missing="$(wc -l <"$LOG_FILE" | tr -d ' ')"
assert_equals "$line_count_before_missing" "$line_count_after_missing" "missing command should not launch process"
assert_equals "$last_agent_before_missing" "$(tmux -S "$socket_path" show-option -gqv '@workspace_agent_last_agent')" "missing command should not mutate last-agent option"
assert_equals "$state_before_missing" "$(read_state_env "$state_file")" "missing command should not mutate state file"

printf 'agent picker test passed\n'
