#!/usr/bin/env bash
set -euo pipefail

socket_path="${1:-}"
pane_id="${2:-}"
pane_current_path="${3:-}"
action="${4:-menu}"
arg1="${5:-}"
arg2="${6:-}"

if [ -z "$socket_path" ] || [ -z "$pane_id" ]; then
	echo "workspace-agent: launcher context is missing" >&2
	exit 1
fi

tmux_cmd() {
	tmux -S "$socket_path" "$@"
}

display_feedback() {
	local message="$1"

	if ! tmux_cmd display-message -t "$pane_id" "$message" 2>/dev/null; then
		tmux_cmd display-message "$message" 2>/dev/null || true
	fi
}

trim() {
	local value="$1"
	value="${value#"${value%%[![:space:]]*}"}"
	value="${value%"${value##*[![:space:]]}"}"
	printf '%s' "$value"
}

session_exists() {
	local session_name="$1"
	tmux_cmd has-session -t "$session_name" >/dev/null 2>&1
}

current_session() {
	tmux_cmd display-message -p -t "$pane_id" '#{session_name}'
}

first_client_for_session() {
	local session_name="$1"
	tmux_cmd list-clients -F '#{client_tty}|#{session_name}' |
		awk -F '|' -v session_name="$session_name" '$2 == session_name { print $1; exit }'
}

list_actions() {
	printf 'create\nswitch\nrename\nkill\nexit\n'
}

create_workspace() {
	local raw_name="$1"
	local workspace_name

	workspace_name="$(trim "$raw_name")"
	if [ -z "$workspace_name" ]; then
		display_feedback "workspace-agent: create rejected (blank workspace name)"
		return 1
	fi

	if session_exists "$workspace_name"; then
		display_feedback "workspace-agent: create rejected (workspace '$workspace_name' already exists)"
		return 1
	fi

	tmux_cmd new-session -d -s "$workspace_name"
	display_feedback "workspace-agent: created workspace '$workspace_name'"
}

switch_workspace() {
	local raw_target="$1"
	local target_workspace
	local current_workspace
	local client_tty

	target_workspace="$(trim "$raw_target")"
	if [ -z "$target_workspace" ]; then
		display_feedback "workspace-agent: switch rejected (blank workspace name)"
		return 1
	fi

	if ! session_exists "$target_workspace"; then
		display_feedback "workspace-agent: switch rejected (workspace '$target_workspace' is missing)"
		return 1
	fi

	current_workspace="$(current_session)"
	if [ "$target_workspace" = "$current_workspace" ]; then
		display_feedback "workspace-agent: already on workspace '$target_workspace'"
		return 0
	fi

	client_tty="$(first_client_for_session "$current_workspace")"
	if [ -z "$client_tty" ]; then
		display_feedback "workspace-agent: switch rejected (no active client for workspace '$current_workspace')"
		return 1
	fi
	tmux_cmd switch-client -c "$client_tty" -t "$target_workspace"

	display_feedback "workspace-agent: switched to workspace '$target_workspace'"
}

rename_workspace() {
	local source_workspace="$1"
	local raw_target="$2"
	local target_workspace

	source_workspace="$(trim "$source_workspace")"
	target_workspace="$(trim "$raw_target")"

	if [ -z "$source_workspace" ]; then
		source_workspace="$(current_session)"
	fi

	if [ -z "$target_workspace" ]; then
		display_feedback "workspace-agent: rename rejected (blank workspace name)"
		return 1
	fi

	if ! session_exists "$source_workspace"; then
		display_feedback "workspace-agent: rename rejected (workspace '$source_workspace' is missing)"
		return 1
	fi

	if [ "$source_workspace" = "$target_workspace" ]; then
		display_feedback "workspace-agent: rename rejected (source and target match)"
		return 1
	fi

	if session_exists "$target_workspace"; then
		display_feedback "workspace-agent: rename rejected (workspace '$target_workspace' already exists)"
		return 1
	fi

	tmux_cmd rename-session -t "$source_workspace" "$target_workspace"
	display_feedback "workspace-agent: renamed '$source_workspace' -> '$target_workspace'"
}

prompt_create() {
	tmux_cmd command-prompt -t "$pane_id" -p "Create workspace name:" \
		"run-shell '$0 \"$socket_path\" \"$pane_id\" \"$pane_current_path\" create-input \"%%\"'"
}

prompt_switch() {
	tmux_cmd command-prompt -t "$pane_id" -p "Switch to workspace:" \
		"run-shell '$0 \"$socket_path\" \"$pane_id\" \"$pane_current_path\" switch-input \"%%\"'"
}

prompt_rename() {
	local source_workspace
	source_workspace="$(current_session)"
	tmux_cmd command-prompt -t "$pane_id" -I "$source_workspace" -p "Rename workspace (${source_workspace} ->):" \
		"run-shell '$0 \"$socket_path\" \"$pane_id\" \"$pane_current_path\" rename-input \"$source_workspace\" \"%%\"'"
}

show_launcher() {
	tmux_cmd display-menu -t "$pane_id" -T "workspace-agent launcher" \
		"Create workspace" c "run-shell '$0 \"$socket_path\" \"$pane_id\" \"$pane_current_path\" create-prompt'" \
		"Switch workspace" s "run-shell '$0 \"$socket_path\" \"$pane_id\" \"$pane_current_path\" switch-prompt'" \
		"Rename workspace" r "run-shell '$0 \"$socket_path\" \"$pane_id\" \"$pane_current_path\" rename-prompt'" \
		"Kill workspace (coming soon)" x "run-shell '$0 \"$socket_path\" \"$pane_id\" \"$pane_current_path\" kill-info'" \
		"" "" "" \
		"Exit launcher" q ""
}

case "$action" in
menu | show-menu | "")
	show_launcher
	;;
list-actions)
	list_actions
	;;
create-prompt)
	prompt_create
	;;
switch-prompt)
	prompt_switch
	;;
rename-prompt)
	prompt_rename
	;;
create | create-input)
	create_workspace "$arg1"
	;;
switch | switch-input)
	switch_workspace "$arg1"
	;;
rename)
	rename_workspace "$arg1" "$arg2"
	;;
rename-input)
	rename_workspace "$arg1" "$arg2"
	;;
kill-info)
	display_feedback "workspace-agent: kill flow is available from launcher (implementation follows in kill milestone)"
	;;
*)
	echo "workspace-agent: unknown launcher action '$action'" >&2
	exit 1
	;;
esac
