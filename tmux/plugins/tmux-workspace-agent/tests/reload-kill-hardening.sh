#!/usr/bin/env bash

set -euo pipefail

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(cd "$CURRENT_DIR/.." && pwd)"
LAUNCHER_SCRIPT="$PLUGIN_DIR/scripts/launch-menu.sh"
QUICK_RELAUNCH_SCRIPT="$PLUGIN_DIR/scripts/quick-relaunch.sh"
TMUX_CONF="/Users/ict/.config/tmux/tmux.conf"
SOCKET="workspace-agent-reload-kill-$$"

TMP_ROOT="$(mktemp -d "/tmp/workspace-agent-reload-kill.XXXXXX")"
BIN_DIR="$TMP_ROOT/bin"
LOG_FILE="$TMP_ROOT/agent-launch.log"
STATE_HOME="$TMP_ROOT/state"
mkdir -p "$BIN_DIR" "$STATE_HOME"
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

assert_contains() {
	local needle="$1"
	local haystack="$2"
	local message="$3"
	case "$haystack" in
		*"$needle"*) ;;
		*)
			printf '%s: expected to contain [%s], got [%s]\n' "$message" "$needle" "$haystack" >&2
			exit 1
			;;
	esac
}

assert_not_contains() {
	local needle="$1"
	local haystack="$2"
	local message="$3"
	case "$haystack" in
		*"$needle"*)
			printf '%s: expected to NOT contain [%s], got [%s]\n' "$message" "$needle" "$haystack" >&2
			exit 1
			;;
		*) ;;
	esac
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

PATH="$BIN_DIR:$PATH" tmux -L "$SOCKET" -f "$TMUX_CONF" new-session -d -s crossw1
PATH="$BIN_DIR:$PATH" tmux -L "$SOCKET" source-file "$TMUX_CONF"
PATH="$BIN_DIR:$PATH" tmux -L "$SOCKET" new-session -d -s crossw2

socket_path="$(tmux -L "$SOCKET" display-message -p -t crossw1:1.1 '#{socket_path}')"
pane_w1="$(tmux -S "$socket_path" display-message -p -t crossw1:1.1 '#{pane_id}')"
pane_w2="$(tmux -S "$socket_path" display-message -p -t crossw2:1.1 '#{pane_id}')"
state_file="$STATE_HOME/tmux-workspace-agent/state.env"

w1_launch_path="$TMP_ROOT/w1 launch"
mkdir -p "$w1_launch_path"
PATH="$BIN_DIR:$PATH" XDG_STATE_HOME="$STATE_HOME" \
	"$LAUNCHER_SCRIPT" "$socket_path" "$pane_w1" "$w1_launch_path" launch-agent "opencode"
wait_for_log_lines 1
assert_equals "opencode|$w1_launch_path" "$(tail -n 1 "$LOG_FILE")" "initial launch should use w1 caller path"

segment_before_reload="$(tmux -S "$socket_path" show-option -gqv '@workspace_agent_status_segment')"
assert_contains "crossw1" "$segment_before_reload" "status segment should include active workspace before reload"
assert_contains "opencode" "$segment_before_reload" "status segment should include launched agent before reload"
assert_contains "running" "$segment_before_reload" "status segment should include running status before reload"

tmux -S "$socket_path" source-file "$TMUX_CONF"

prefix_keys="$(tmux -S "$socket_path" list-keys -T prefix)"
workspace_keys="$(tmux -S "$socket_path" list-keys -T workspace_agent)"
assert_contains "switch-client -T workspace_agent" "$prefix_keys" "prefix table should preserve namespace route after reload"
assert_contains "-T workspace_agent a " "$workspace_keys" "workspace_agent table should preserve launcher binding after reload"
assert_contains "-T workspace_agent A " "$workspace_keys" "workspace_agent table should preserve quick relaunch binding after reload"

w1_relaunch_path="$TMP_ROOT/w1 relaunch"
mkdir -p "$w1_relaunch_path"
PATH="$BIN_DIR:$PATH" XDG_STATE_HOME="$STATE_HOME" \
	"$QUICK_RELAUNCH_SCRIPT" "$socket_path" "$pane_w1" "$w1_relaunch_path"
wait_for_log_lines 2
assert_equals "opencode|$w1_relaunch_path" "$(tail -n 1 "$LOG_FILE")" "quick relaunch should remain functional after reload"

XDG_STATE_HOME="$STATE_HOME" "$LAUNCHER_SCRIPT" "$socket_path" "$pane_w1" "$HOME" kill-input "crossw1" "YES"
if tmux -S "$socket_path" has-session -t crossw1 2>/dev/null; then
	printf 'expected crossw1 session to be killed\n' >&2
	exit 1
fi

segment_after_kill="$(tmux -S "$socket_path" show-option -gqv '@workspace_agent_status_segment')"
assert_not_contains "crossw1" "$segment_after_kill" "status segment should clear deleted workspace identity"
assert_contains "crossw2" "$segment_after_kill" "status segment should move to fallback workspace identity"

state_snapshot="$(read_state_env "$state_file")"
IFS='|' read -r state_agent state_workspace state_status state_path <<EOF
$state_snapshot
EOF
fallback_path="$(tmux -S "$socket_path" display-message -p -t crossw2:1.1 '#{pane_current_path}')"
assert_equals "opencode" "$state_agent" "kill cleanup should preserve last agent identity"
assert_equals "crossw2" "$state_workspace" "kill cleanup should update last workspace to fallback workspace"
assert_equals "idle" "$state_status" "kill cleanup should set idle status after workspace removal"
assert_equals "$fallback_path" "$state_path" "kill cleanup should update last path to fallback workspace pane path"

w2_relaunch_path="$TMP_ROOT/w2 relaunch quote' [ok]"
mkdir -p "$w2_relaunch_path"
PATH="$BIN_DIR:$PATH" XDG_STATE_HOME="$STATE_HOME" \
	"$QUICK_RELAUNCH_SCRIPT" "$socket_path" "$pane_w2" "$w2_relaunch_path"
wait_for_log_lines 3
assert_equals "opencode|$w2_relaunch_path" "$(tail -n 1 "$LOG_FILE")" "post-kill quick relaunch should use fallback workspace caller path"

printf 'reload/kill hardening test passed\n'
