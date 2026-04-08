#!/usr/bin/env bash

set -euo pipefail

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(cd "$CURRENT_DIR/.." && pwd)"
SCRIPT_DIR="$PLUGIN_DIR/scripts"
LAUNCHER_SCRIPT="$SCRIPT_DIR/launch-menu.sh"
AGENT_SCRIPT="$SCRIPT_DIR/agent-launch.sh"
QUICK_RELAUNCH_SCRIPT="$SCRIPT_DIR/quick-relaunch.sh"
STATUS_SYNC_SCRIPT="$SCRIPT_DIR/status-sync.sh"
TMUX_CONF="/Users/ict/.config/tmux/tmux.conf"
SOCKET="workspace-agent-script-gate-$$"
TMP_ROOT="$(mktemp -d "/tmp/workspace-agent-script-gate.XXXXXX")"
BIN_DIR="$TMP_ROOT/bin"
LOG_FILE="$TMP_ROOT/agent-launch.log"
mkdir -p "$BIN_DIR"
touch "$LOG_FILE"

cleanup() {
	tmux -L "$SOCKET" kill-server >/dev/null 2>&1 || true
	rm -rf "$TMP_ROOT"
}

trap cleanup EXIT

run_expect_fail_contains() {
	local expected_message="$1"
	shift
	local output
	local exit_code

	set +e
	output="$("$@" 2>&1)"
	exit_code=$?
	set -e

	if [ "$exit_code" -eq 0 ]; then
		printf 'expected command to fail but it succeeded: %s\n' "$*" >&2
		exit 1
	fi

	case "$output" in
	*"$expected_message"*) ;;
	*)
		printf 'expected output to contain [%s], got [%s]\n' "$expected_message" "$output" >&2
		exit 1
		;;
	esac
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

install_stub_agent() {
	local agent="$1"
	cat >"$BIN_DIR/$agent" <<EOF
#!/usr/bin/env bash
printf '%s|%s\n' "$agent" "\$PWD" >> "$LOG_FILE"
EOF
	chmod +x "$BIN_DIR/$agent"
}

run_expect_fail_contains "workspace-agent: launcher context is missing" "$LAUNCHER_SCRIPT"
run_expect_fail_contains "workspace-agent: agent launch context is missing" "$AGENT_SCRIPT"
run_expect_fail_contains "workspace-agent: quick relaunch context is missing" "$QUICK_RELAUNCH_SCRIPT"
run_expect_fail_contains "workspace-agent: status sync missing socket path" "$STATUS_SYNC_SCRIPT"

install_stub_agent "codex"

PATH="$BIN_DIR:$PATH" tmux -L "$SOCKET" -f "$TMUX_CONF" new-session -d -s scriptgate
PATH="$BIN_DIR:$PATH" tmux -L "$SOCKET" source-file "$TMUX_CONF"
tmux -L "$SOCKET" new-session -d -s scriptgate_alt
socket_path="$(tmux -L "$SOCKET" display-message -p -t scriptgate:1.1 '#{socket_path}')"
pane_id="$(tmux -S "$socket_path" display-message -p -t scriptgate:1.1 '#{pane_id}')"

tmux -S "$socket_path" set-environment -g PATH "$BIN_DIR:$PATH"
tmux -S "$socket_path" set-option -gq '@workspace_agent_popup_mode' '0'

run_expect_fail_contains "workspace-agent: unknown launcher action 'bogus-action'" \
	"$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" "bogus-action"

special_path="$TMP_ROOT/fallback quote' path [x] !"
mkdir -p "$special_path"

fallback_launch_cmd="$("$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$special_path" "__build-run-shell-command" "launch-agent" "codex" "" "")"
tmux -S "$socket_path" if-shell -F "1" "$fallback_launch_cmd"
wait_for_log_lines 1
assert_equals "codex|$special_path" "$(tail -n 1 "$LOG_FILE")" "fallback launch command should preserve shell-special caller path"

quoted_workspace="fallback quote'workspace"
fallback_create_cmd="$("$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$special_path" "__build-run-shell-command" "create-input" "$quoted_workspace" "" "")"
tmux -S "$socket_path" if-shell -F "1" "$fallback_create_cmd"
tmux -S "$socket_path" has-session -t "$quoted_workspace"

fallback_kill_cmd="$("$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$special_path" "__build-run-shell-command" "kill-input" "$quoted_workspace" "" "YES")"
tmux -S "$socket_path" if-shell -F "1" "$fallback_kill_cmd"
if tmux -S "$socket_path" has-session -t "$quoted_workspace" 2>/dev/null; then
	printf 'expected quoted workspace [%s] to be killed via fallback command path\n' "$quoted_workspace" >&2
	exit 1
fi

unsafe_fallback_refs="$(rg -n "run-shell '\\\$0" "$LAUNCHER_SCRIPT" || true)"
if [ -n "$unsafe_fallback_refs" ]; then
	printf 'unsafe fallback run-shell interpolation remains:\n%s\n' "$unsafe_fallback_refs" >&2
	exit 1
fi

if ! rg -n "build_run_shell_command" "$LAUNCHER_SCRIPT" >/dev/null; then
	printf 'expected launch-menu.sh to define build_run_shell_command helper\n' >&2
	exit 1
fi

raw_tmux_refs="$(rg -n "tmux " "$SCRIPT_DIR"/*.sh || true)"
unsafe_tmux_refs="$(printf '%s\n' "$raw_tmux_refs" | rg -v 'tmux_cmd\(\)|tmux -S "\$socket_path" "\$@"|command -v tmux' || true)"
if [ -n "$unsafe_tmux_refs" ]; then
	printf 'found tmux calls that are not explicitly socket-targeted:\n%s\n' "$unsafe_tmux_refs" >&2
	exit 1
fi

printf 'script gate test passed\n'
