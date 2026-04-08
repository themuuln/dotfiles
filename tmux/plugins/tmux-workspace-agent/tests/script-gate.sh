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

cleanup() {
	tmux -L "$SOCKET" kill-server >/dev/null 2>&1 || true
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

run_expect_fail_contains "workspace-agent: launcher context is missing" "$LAUNCHER_SCRIPT"
run_expect_fail_contains "workspace-agent: agent launch context is missing" "$AGENT_SCRIPT"
run_expect_fail_contains "workspace-agent: quick relaunch context is missing" "$QUICK_RELAUNCH_SCRIPT"
run_expect_fail_contains "workspace-agent: status sync missing socket path" "$STATUS_SYNC_SCRIPT"

tmux -L "$SOCKET" -f "$TMUX_CONF" new-session -d -s scriptgate
tmux -L "$SOCKET" source-file "$TMUX_CONF"
socket_path="$(tmux -L "$SOCKET" display-message -p -t scriptgate:1.1 '#{socket_path}')"
pane_id="$(tmux -S "$socket_path" display-message -p -t scriptgate:1.1 '#{pane_id}')"

run_expect_fail_contains "workspace-agent: unknown launcher action 'bogus-action'" \
	"$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" "bogus-action"

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
