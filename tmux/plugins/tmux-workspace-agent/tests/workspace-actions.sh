#!/usr/bin/env bash

set -euo pipefail

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(cd "$CURRENT_DIR/.." && pwd)"
LAUNCHER_SCRIPT="$PLUGIN_DIR/scripts/launch-menu.sh"
TMUX_CONF="/Users/ict/.config/tmux/tmux.conf"
SOCKET="workspace-agent-actions-$$"

cleanup() {
	tmux -L "$SOCKET" kill-server >/dev/null 2>&1 || true
}

trap cleanup EXIT

assert_session_exists() {
	local socket_path="$1"
	local session_name="$2"
	tmux -S "$socket_path" has-session -t "$session_name"
}

assert_session_missing() {
	local socket_path="$1"
	local session_name="$2"
	if tmux -S "$socket_path" has-session -t "$session_name" 2>/dev/null; then
		printf 'expected session %s to be missing\n' "$session_name" >&2
		exit 1
	fi
}

assert_pane_session() {
	local socket_path="$1"
	local pane_id="$2"
	local expected_session="$3"
	local current_session

	current_session="$(tmux -S "$socket_path" display-message -p -t "$pane_id" '#{session_name}')"

	[ "$current_session" = "$expected_session" ] || {
		printf 'expected pane session %s, got %s\n' "$expected_session" "$current_session" >&2
		exit 1
	}
}

run_expect_fail() {
	if "$@"; then
		printf 'expected command to fail: %s\n' "$*" >&2
		exit 1
	fi
}

tmux -L "$SOCKET" -f "$TMUX_CONF" new-session -d -s wsbase
tmux -L "$SOCKET" source-file "$TMUX_CONF"
tmux -L "$SOCKET" new-session -d -s sibling

socket_path="$(tmux -L "$SOCKET" display-message -p -t wsbase:1.1 '#{socket_path}')"
pane_id="$(tmux -S "$socket_path" display-message -p -t wsbase:1.1 '#{pane_id}')"

"$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" list-actions |
	grep -Eq '^create$'
"$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" list-actions |
	grep -Eq '^switch$'
"$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" list-actions |
	grep -Eq '^rename$'
"$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" list-actions |
	grep -Eq '^kill$'

"$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" create-input "dev"
assert_session_exists "$socket_path" "dev"

session_count_before="$(tmux -S "$socket_path" list-sessions | wc -l | tr -d ' ')"
run_expect_fail "$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" create-input "dev"
run_expect_fail "$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" create-input ""
run_expect_fail "$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" create-input "   "
session_count_after="$(tmux -S "$socket_path" list-sessions | wc -l | tr -d ' ')"
[ "$session_count_before" = "$session_count_after" ] || {
	printf 'expected session count unchanged for create failures (%s != %s)\n' "$session_count_before" "$session_count_after" >&2
	exit 1
}

run_expect_fail "$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" switch-input "dev"
assert_pane_session "$socket_path" "$pane_id" "wsbase"

run_expect_fail "$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" switch-input "missing-workspace"
assert_pane_session "$socket_path" "$pane_id" "wsbase"

"$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" switch-input "wsbase"
assert_pane_session "$socket_path" "$pane_id" "wsbase"

"$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" create-input "existing"
"$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" rename "dev" "renamed"
assert_session_exists "$socket_path" "renamed"
assert_session_missing "$socket_path" "dev"

run_expect_fail "$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" rename "renamed" "renamed"
run_expect_fail "$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" rename "renamed" "existing"
run_expect_fail "$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" rename "renamed" "   "
assert_session_exists "$socket_path" "renamed"
assert_session_exists "$socket_path" "existing"

fallback_target="$("$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" kill-fallback "wsbase")"
[ "$fallback_target" = "existing" ] || {
	printf 'expected deterministic fallback existing, got %s\n' "$fallback_target" >&2
	exit 1
}

"$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" kill-input "renamed" "NO"
assert_session_exists "$socket_path" "renamed"

"$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" kill-input "renamed" "YES"
assert_session_missing "$socket_path" "renamed"

run_expect_fail "$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" kill-input "missing-workspace" "YES"

tmux -S "$socket_path" set-option -gq "@workspace_agent_popup_mode" "0"
"$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" create-input "popup_fallback_ws"
assert_session_exists "$socket_path" "popup_fallback_ws"
"$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" kill-input "popup_fallback_ws" "YES"
assert_session_missing "$socket_path" "popup_fallback_ws"

"$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" kill-input "sibling" "YES"
"$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" kill-input "existing" "YES"
assert_session_exists "$socket_path" "wsbase"
run_expect_fail "$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" kill-input "wsbase" "YES"
assert_session_exists "$socket_path" "wsbase"

printf 'workspace actions test passed\n'
