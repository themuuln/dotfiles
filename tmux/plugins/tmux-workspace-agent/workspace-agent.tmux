#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$CURRENT_DIR/scripts"

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
	tmux bind-key -T workspace_agent "$menu_key" run-shell "$SCRIPTS_DIR/launch-menu.sh '#{socket_path}' '#{pane_id}' '#{pane_current_path}'"
	tmux bind-key -T workspace_agent "$quick_key" run-shell "$SCRIPTS_DIR/quick-relaunch.sh '#{socket_path}' '#{pane_id}' '#{pane_current_path}'"
	tmux bind-key -T workspace_agent q switch-client -T prefix
	tmux bind-key -T workspace_agent Escape switch-client -T prefix
	tmux bind-key -T workspace_agent '?' display-message "workspace-agent: a=launcher(create/switch/rename/kill) A=quick-relaunch q/Escape=exit"

	tmux set-option -gq "@workspace_agent_bound_namespace_key" "$namespace_key"
	tmux set-option -gq "@workspace_agent_bound_menu_key" "$menu_key"
	tmux set-option -gq "@workspace_agent_bound_quick_key" "$quick_key"
}

main() {
	set_default_options
	set_key_bindings
}

main
