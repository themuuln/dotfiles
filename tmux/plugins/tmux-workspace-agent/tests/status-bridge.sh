#!/usr/bin/env bash

set -euo pipefail

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(cd "$CURRENT_DIR/.." && pwd)"
LAUNCHER_SCRIPT="$PLUGIN_DIR/scripts/launch-menu.sh"
TMUX_CONF="/Users/ict/.config/tmux/tmux.conf"
SOCKET="workspace-agent-status-bridge-$$"

TMP_ROOT="$(mktemp -d "/tmp/workspace-agent-status-bridge.XXXXXX")"
BIN_DIR="$TMP_ROOT/bin"
STATE_HOME="$TMP_ROOT/state"
LOG_FILE="$TMP_ROOT/agent-launch.log"
switch_fifo=""
switch_log=""
switch_cat_pid=""
mkdir -p "$BIN_DIR" "$STATE_HOME"
touch "$LOG_FILE"

cleanup() {
	if [ -n "$switch_cat_pid" ]; then
		kill "$switch_cat_pid" >/dev/null 2>&1 || true
	fi
	if [ -n "$switch_fifo" ]; then
		rm -f "$switch_fifo"
	fi
	if [ -n "$switch_log" ]; then
		rm -f "$switch_log"
	fi
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

install_stub_agent() {
	local agent="$1"
	cat >"$BIN_DIR/$agent" <<EOF
#!/usr/bin/env bash
printf '%s|%s\n' "$agent" "\$PWD" >> "$LOG_FILE"
EOF
	chmod +x "$BIN_DIR/$agent"
}

count_substring() {
	local value="$1"
	local needle="$2"
	python3 - "$value" "$needle" <<'PY'
import sys
print(sys.argv[1].count(sys.argv[2]))
PY
}

sidebar_state_status() {
	local socket_path="$1"
	local pane_id="$2"
	python3 - "$socket_path" "$pane_id" <<'PY'
import json
import hashlib
import os
import sys

socket_path = sys.argv[1]
pane_id = sys.argv[2]
cache_root = os.path.join(os.environ.get("XDG_CACHE_HOME", os.path.expanduser("~/.cache")), "tmux-workspace-sidebar")
socket_hash = hashlib.sha256((socket_path + "\n").encode("utf-8")).hexdigest()
state_file = os.path.join(cache_root, socket_hash, "state", f"pane-{pane_id}.json")

if not os.path.exists(state_file):
    print("")
    raise SystemExit(0)

try:
    with open(state_file, "r", encoding="utf-8") as f:
        payload = json.load(f)
except Exception:
    print("")
    raise SystemExit(0)

print(str(payload.get("status") or ""))
PY
}

install_stub_agent "codex"

tmux -L "$SOCKET" -f "$TMUX_CONF" new-session -d -s statusws
tmux -L "$SOCKET" source-file "$TMUX_CONF"

socket_path="$(tmux -L "$SOCKET" display-message -p -t statusws:1.1 '#{socket_path}')"
pane_id="$(tmux -S "$socket_path" display-message -p -t statusws:1.1 '#{pane_id}')"

status_right="$(tmux -S "$socket_path" show-option -gqv status-right)"
assert_contains "#{@workspace_agent_status_segment}" "$status_right" "status-right should include workspace-agent status segment token"

segment="$(tmux -S "$socket_path" show-option -gqv '@workspace_agent_status_segment')"
assert_contains "wa:" "$segment" "standalone segment should be initialized"
assert_not_contains "bridge" "$segment" "bridge label should be absent in standalone mode"

assert_equals "0" "$(tmux -S "$socket_path" show-option -gqv '@workspace_agent_bridge')" "bridge should default to disabled"

window_opts_before="$(tmux -S "$socket_path" show-option -gqv '@window_name_lite_status_suffix_enabled')|$(tmux -S "$socket_path" show-option -gqv '@window_name_lite_status_suffix_separator')"
sidebar_opts_before="$(tmux -S "$socket_path" show-option -gqv '@workspace_sidebar_session_keys')|$(tmux -S "$socket_path" show-option -gqv '@workspace_sidebar_push_enabled')"

launch_path="$TMP_ROOT/launch-path"
mkdir -p "$launch_path"
PATH="$BIN_DIR:$PATH" XDG_STATE_HOME="$STATE_HOME" \
	"$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$launch_path" launch-agent "codex"

segment_after_launch="$(tmux -S "$socket_path" show-option -gqv '@workspace_agent_status_segment')"
assert_contains "statusws" "$segment_after_launch" "segment should include workspace identity after launch"
assert_contains "codex" "$segment_after_launch" "segment should include launched agent identity"
case "$segment_after_launch" in
	*"running"* | *"launched"*) ;;
	*)
		printf 'segment should include launch status label, got [%s]\n' "$segment_after_launch" >&2
		exit 1
		;;
esac

"$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" create-input "statusws_alt"
segment_after_create="$(tmux -S "$socket_path" show-option -gqv '@workspace_agent_status_segment')"
assert_contains "statusws_alt" "$segment_after_create" "create should propagate workspace identity to status segment"
assert_contains "codex" "$segment_after_create" "create should preserve active agent identity in status segment"

switch_fifo="/tmp/workspace-agent-status-bridge-switch-$$.fifo"
switch_log="/tmp/workspace-agent-status-bridge-switch-$$.log"
rm -f "$switch_fifo" "$switch_log"
mkfifo "$switch_fifo"
cat "$switch_fifo" | tmux -S "$socket_path" -C attach-session -t statusws >"$switch_log" 2>&1 &
switch_cat_pid=$!
exec 3>"$switch_fifo"
sleep 0.5

switch_client_name="$(tmux -S "$socket_path" list-clients -F '#{client_name}' | awk 'NR == 1 { print; exit }')"
[ -n "$switch_client_name" ] || {
	printf 'expected an attached client for switch status checks\n' >&2
	exit 1
}

"$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" switch-input "statusws_alt" "" "$switch_client_name"
segment_after_switch="$(tmux -S "$socket_path" show-option -gqv '@workspace_agent_status_segment')"
assert_contains "statusws_alt" "$segment_after_switch" "switch should propagate target workspace identity to status segment"
assert_contains "codex" "$segment_after_switch" "switch should preserve active agent identity in status segment"

"$LAUNCHER_SCRIPT" "$socket_path" "$pane_id" "$HOME" rename "statusws_alt" "statusws_renamed"
segment_after_rename="$(tmux -S "$socket_path" show-option -gqv '@workspace_agent_status_segment')"
assert_contains "statusws_renamed" "$segment_after_rename" "rename should propagate renamed workspace identity to status segment"
assert_contains "codex" "$segment_after_rename" "rename should preserve active agent identity in status segment"

printf 'detach-client\n' >&3
exec 3>&-
kill "$switch_cat_pid" 2>/dev/null || true
rm -f "$switch_fifo" "$switch_log"
switch_cat_pid=""
switch_fifo=""
switch_log=""

tmux -S "$socket_path" set-option -gq '@workspace_agent_bridge' '1'
tmux -S "$socket_path" source-file "$TMUX_CONF"
segment_bridge_on="$(tmux -S "$socket_path" show-option -gqv '@workspace_agent_status_segment')"
assert_contains "bridge" "$segment_bridge_on" "bridge label should appear when enabled"

status_right_after_reload="$(tmux -S "$socket_path" show-option -gqv status-right)"
token_count="$(count_substring "$status_right_after_reload" "#{@workspace_agent_status_segment}")"
assert_equals "1" "$token_count" "status-right token should remain single across reloads"

tmux -S "$socket_path" source-file "$TMUX_CONF"
status_right_after_second_reload="$(tmux -S "$socket_path" show-option -gqv status-right)"
token_count_second="$(count_substring "$status_right_after_second_reload" "#{@workspace_agent_status_segment}")"
assert_equals "1" "$token_count_second" "status-right token should remain single across repeated reloads"

tmux -S "$socket_path" set-option -gq '@workspace_agent_bridge' '0'
tmux -S "$socket_path" source-file "$TMUX_CONF"
segment_bridge_off="$(tmux -S "$socket_path" show-option -gqv '@workspace_agent_status_segment')"
assert_not_contains "bridge" "$segment_bridge_off" "bridge label should clear after disabling bridge"

state_status_after_bridge_off="$(sidebar_state_status "$socket_path" "$pane_id")"
assert_equals "" "$state_status_after_bridge_off" "bridge-off should clear bridged sidebar status"

window_opts_after="$(tmux -S "$socket_path" show-option -gqv '@window_name_lite_status_suffix_enabled')|$(tmux -S "$socket_path" show-option -gqv '@window_name_lite_status_suffix_separator')"
sidebar_opts_after="$(tmux -S "$socket_path" show-option -gqv '@workspace_sidebar_session_keys')|$(tmux -S "$socket_path" show-option -gqv '@workspace_sidebar_push_enabled')"
assert_equals "$window_opts_before" "$window_opts_after" "window-name-lite options should stay unchanged"
assert_equals "$sidebar_opts_before" "$sidebar_opts_after" "workspace-sidebar options should stay unchanged"

printf 'status bridge test passed\n'
