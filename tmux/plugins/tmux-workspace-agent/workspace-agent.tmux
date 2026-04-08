#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$CURRENT_DIR/scripts"
STATUS_SYNC_SCRIPT="$SCRIPTS_DIR/status-sync.sh"
ENSURE_STATUS_RIGHT_SCRIPT="$SCRIPTS_DIR/ensure-status-right.sh"

set_if_unset() {
	local key="$1"
	local default_value="$2"
	local current_value
	current_value="$(tmux show-option -gqv "$key")"
	if [ -z "$current_value" ]; then
		tmux set-option -gq "$key" "$default_value"
	fi
}

set_default_options() {
	tmux set-option -gq "@workspace_agent_plugin_dir" "$CURRENT_DIR"
	set_if_unset "@workspace_agent_namespace_key" "g"
	set_if_unset "@workspace_agent_menu_key" "a"
	set_if_unset "@workspace_agent_quick_key" "A"
	set_if_unset "@workspace_agent_clis" "opencode,codex,droid,pi"
	set_if_unset "@workspace_agent_bridge" "0"
	set_if_unset "@workspace_agent_popup_mode" "1"
	set_if_unset "@workspace_agent_last_agent" ""
	set_if_unset "@workspace_agent_last_workspace" ""
	set_if_unset "@workspace_agent_last_status" "idle"
	set_if_unset "@workspace_agent_last_path" ""
	set_if_unset "@workspace_agent_status_segment" "[wa:idle]"
	set_if_unset "@workspace_agent_bridge_state" "standalone"
}

set_status_segment_binding() {
	local status_right
	local segment_token

	status_right="$(tmux show-option -gqv status-right)"
	segment_token='#{@workspace_agent_status_segment}'

	case "$status_right" in
	*"$segment_token"*)
		return 0
		;;
	esac

	if [ -n "$status_right" ]; then
		tmux set-option -gq status-right "${status_right} ${segment_token}"
	else
		tmux set-option -gq status-right "$segment_token"
	fi
}

append_hook_command_if_missing() {
	local hook_name="$1"
	local hook_command="$2"
	local match_token="$3"
	local existing_hooks

	existing_hooks="$(tmux show-hooks -g "$hook_name" 2>/dev/null || true)"

	case "$existing_hooks" in
	*"$match_token"*)
		return 0
		;;
	esac

	tmux set-hook -ag "$hook_name" "$hook_command"
}

set_status_hooks() {
	local sync_hook_cmd
	local ensure_status_right_cmd

	sync_hook_cmd="run-shell -b '$STATUS_SYNC_SCRIPT \"#{socket_path}\" \"#{pane_id}\" \"#{pane_current_path}\" \"\" \"\" \"\"'"
	ensure_status_right_cmd="run-shell -b '$ENSURE_STATUS_RIGHT_SCRIPT \"#{socket_path}\"'"

	append_hook_command_if_missing "after-select-pane" "$sync_hook_cmd" "$STATUS_SYNC_SCRIPT"
	append_hook_command_if_missing "after-select-window" "$sync_hook_cmd" "$STATUS_SYNC_SCRIPT"
	append_hook_command_if_missing "client-session-changed" "$sync_hook_cmd" "$STATUS_SYNC_SCRIPT"
	append_hook_command_if_missing "after-new-session" "$sync_hook_cmd" "$STATUS_SYNC_SCRIPT"
	append_hook_command_if_missing "after-new-window" "$sync_hook_cmd" "$STATUS_SYNC_SCRIPT"
	append_hook_command_if_missing "after-split-window" "$sync_hook_cmd" "$STATUS_SYNC_SCRIPT"
	append_hook_command_if_missing "after-set-option" "$ensure_status_right_cmd" "$ENSURE_STATUS_RIGHT_SCRIPT"
	append_hook_command_if_missing "session-renamed" "$sync_hook_cmd" "$STATUS_SYNC_SCRIPT"
	append_hook_command_if_missing "window-renamed" "$sync_hook_cmd" "$STATUS_SYNC_SCRIPT"
}

set_key_bindings() {
	local namespace_key
	local menu_key
	local quick_key
	local previous_namespace_key
	local previous_menu_key
	local previous_quick_key

	namespace_key="$(tmux show-option -gqv '@workspace_agent_namespace_key')"
	menu_key="$(tmux show-option -gqv '@workspace_agent_menu_key')"
	quick_key="$(tmux show-option -gqv '@workspace_agent_quick_key')"
	previous_namespace_key="$(tmux show-option -gqv '@workspace_agent_bound_namespace_key')"
	previous_menu_key="$(tmux show-option -gqv '@workspace_agent_bound_menu_key')"
	previous_quick_key="$(tmux show-option -gqv '@workspace_agent_bound_quick_key')"

	if [ -n "$previous_namespace_key" ] && [ "$previous_namespace_key" != "$namespace_key" ]; then
		tmux unbind-key -T prefix "$previous_namespace_key" 2>/dev/null || true
	fi

	if [ -n "$previous_menu_key" ] && [ "$previous_menu_key" != "$menu_key" ]; then
		tmux unbind-key -T workspace_agent "$previous_menu_key" 2>/dev/null || true
	fi

	if [ -n "$previous_quick_key" ] && [ "$previous_quick_key" != "$quick_key" ]; then
		tmux unbind-key -T workspace_agent "$previous_quick_key" 2>/dev/null || true
	fi

	tmux bind-key -T prefix "$namespace_key" switch-client -T workspace_agent
	tmux bind-key -T workspace_agent "$menu_key" run-shell "$SCRIPTS_DIR/launch-menu.sh '#{socket_path}' '#{pane_id}' '#{pane_current_path}' menu '' '' '#{client_name}'"
	tmux bind-key -T workspace_agent "$quick_key" run-shell "$SCRIPTS_DIR/quick-relaunch.sh '#{socket_path}' '#{pane_id}' '#{pane_current_path}'"
	tmux bind-key -T workspace_agent q switch-client -T prefix
	tmux bind-key -T workspace_agent Escape switch-client -T prefix
	tmux bind-key -T workspace_agent '?' display-message "workspace-agent: a=launcher(agents + create/switch/rename/kill) A=quick-relaunch q/Escape=exit"

	tmux set-option -gq "@workspace_agent_bound_namespace_key" "$namespace_key"
	tmux set-option -gq "@workspace_agent_bound_menu_key" "$menu_key"
	tmux set-option -gq "@workspace_agent_bound_quick_key" "$quick_key"
}

main() {
	set_default_options
	set_status_segment_binding
	set_status_hooks
	set_key_bindings
	tmux run-shell "$STATUS_SYNC_SCRIPT '#{socket_path}' '#{pane_id}' '#{pane_current_path}' '' '' ''"
	tmux run-shell -b "sleep 0.2; $STATUS_SYNC_SCRIPT '#{socket_path}' '#{pane_id}' '#{pane_current_path}' '' '' ''"
}

main
