#!/usr/bin/env bash
set -euo pipefail

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_LAUNCH_SCRIPT="$CURRENT_DIR/agent-launch.sh"

socket_path="${1:-}"
pane_id="${2:-}"
pane_current_path="${3:-}"
action="${4:-menu}"
arg1="${5:-}"
arg2="${6:-}"
invoking_client_name="${7:-}"

if [ -z "$socket_path" ] || [ -z "$pane_id" ]; then
	echo "workspace-agent: launcher context is missing" >&2
	exit 1
fi

tmux_cmd() {
	tmux -S "$socket_path" "$@"
}

if [ -z "$invoking_client_name" ]; then
	invoking_client_name="$(tmux_cmd display-message -p -t "$pane_id" '#{client_name}' 2>/dev/null || true)"
fi

display_feedback() {
	local message="$1"

	if ! tmux_cmd display-message -t "$pane_id" "$message" 2>/dev/null; then
		tmux_cmd display-message "$message" 2>/dev/null || true
	fi

	return 0
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

session_count() {
	tmux_cmd list-sessions -F '#{session_name}' | wc -l | tr -d ' '
}

sorted_sessions() {
	tmux_cmd list-sessions -F '#{session_name}' | LC_ALL=C sort
}

deterministic_fallback_workspace() {
	local target_workspace="$1"
	sorted_sessions | awk -v target_workspace="$target_workspace" '$0 != target_workspace { print; exit }'
}

single_quote_escape() {
	local value="$1"
	printf "%s" "$value" | sed "s/'/'\"'\"'/g"
}

shell_quote() {
	local value="$1"
	printf "'%s'" "$(single_quote_escape "$value")"
}

build_self_command() {
	local next_action="$1"
	local first_arg="${2:-}"
	local second_arg="${3:-}"

	printf '%s %s %s %s %s %s %s %s' \
		"$(shell_quote "$0")" \
		"$(shell_quote "$socket_path")" \
		"$(shell_quote "$pane_id")" \
		"$(shell_quote "$pane_current_path")" \
		"$(shell_quote "$next_action")" \
		"$(shell_quote "$first_arg")" \
		"$(shell_quote "$second_arg")" \
		"$(shell_quote "$invoking_client_name")"
}

first_client_for_session() {
	local session_name="$1"
	tmux_cmd list-clients -F '#{client_tty}|#{session_name}' |
		awk -F '|' -v session_name="$session_name" '$2 == session_name { print $1; exit }'
}

all_clients_for_session() {
	local session_name="$1"
	tmux_cmd list-clients -F '#{client_tty}|#{session_name}' |
		awk -F '|' -v session_name="$session_name" '$2 == session_name { print $1 }'
}

list_actions() {
	printf 'create\nswitch\nrename\nkill\nexit\n'
}

list_agents() {
	local configured
	local entry

	configured="$(tmux_cmd show-option -gqv '@workspace_agent_clis' 2>/dev/null || true)"
	if [ -z "$configured" ]; then
		configured="opencode,codex,droid,pi"
	fi

	IFS=',' read -r -a entries <<<"$configured"
	for entry in "${entries[@]}"; do
		entry="$(trim "$entry")"
		[ -n "$entry" ] || continue
		printf '%s\n' "$entry"
	done
}

list_picker_entries() {
	local agent
	while IFS= read -r agent; do
		[ -n "$agent" ] || continue
		printf 'agent:%s\n' "$agent"
	done < <(list_agents)

	printf 'create\nswitch\nrename\nkill\nexit\n'
}

launch_agent() {
	"$AGENT_LAUNCH_SCRIPT" "$socket_path" "$pane_id" "$pane_current_path" "${1:-}"
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
	local target_client

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

	target_client="$invoking_client_name"
	if [ -z "$target_client" ]; then
		target_client="$(first_client_for_session "$current_workspace")"
	fi

	if [ -z "$target_client" ]; then
		display_feedback "workspace-agent: switch rejected (no active client for workspace '$current_workspace')"
		return 1
	fi

	tmux_cmd switch-client -c "$target_client" -t "$target_workspace"

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

prompt_kill_workspace() {
	local source_workspace
	source_workspace="$(current_session)"
	tmux_cmd command-prompt -I "$source_workspace" -p "Kill workspace name:" \
		"run-shell '$0 \"$socket_path\" \"$pane_id\" \"$pane_current_path\" kill-confirm-prompt \"%%\" \"\" \"$invoking_client_name\"'"
}

prompt_kill_confirmation() {
	local target_workspace="$1"
	local fallback_workspace

	target_workspace="$(trim "$target_workspace")"
	if [ -z "$target_workspace" ]; then
		display_feedback "workspace-agent: kill rejected (blank workspace name)"
		return 1
	fi

	if ! session_exists "$target_workspace"; then
		display_feedback "workspace-agent: kill rejected (workspace '$target_workspace' is missing)"
		return 1
	fi

	if [ "$(session_count)" -le 1 ]; then
		display_feedback "workspace-agent: kill rejected (cannot kill the last remaining workspace)"
		return 1
	fi

	fallback_workspace="$(deterministic_fallback_workspace "$target_workspace")"
	if [ -z "$fallback_workspace" ]; then
		display_feedback "workspace-agent: kill rejected (no fallback workspace available)"
		return 1
	fi

	local kill_confirm_cmd
	kill_confirm_cmd="$(build_self_command "kill-confirm" "$target_workspace" "%%")"

	tmux_cmd command-prompt -p "Type YES to kill '$target_workspace' (fallback: '$fallback_workspace'):" \
		"run-shell \"$kill_confirm_cmd\""
}

kill_workspace() {
	local raw_target="$1"
	local confirmation="$2"
	local target_workspace
	local current_workspace
	local fallback_workspace
	local client_tty

	target_workspace="$(trim "$raw_target")"
	confirmation="$(trim "$confirmation")"

	if [ -z "$target_workspace" ]; then
		display_feedback "workspace-agent: kill rejected (blank workspace name)"
		return 1
	fi

	if ! session_exists "$target_workspace"; then
		display_feedback "workspace-agent: kill rejected (workspace '$target_workspace' is missing)"
		return 1
	fi

	if [ "$confirmation" != "YES" ]; then
		display_feedback "workspace-agent: kill canceled for '$target_workspace'"
		return 0
	fi

	if [ "$(session_count)" -le 1 ]; then
		display_feedback "workspace-agent: kill rejected (cannot kill the last remaining workspace)"
		return 1
	fi

	current_workspace="$(current_session)"
	fallback_workspace="$(deterministic_fallback_workspace "$target_workspace")"
	if [ -z "$fallback_workspace" ]; then
		display_feedback "workspace-agent: kill rejected (no fallback workspace available)"
		return 1
	fi

	while IFS= read -r client_tty; do
		[ -n "$client_tty" ] || continue
		tmux_cmd switch-client -c "$client_tty" -t "$fallback_workspace"
	done < <(all_clients_for_session "$target_workspace")

	tmux_cmd kill-session -t "$target_workspace"

	if [ "$target_workspace" = "$current_workspace" ]; then
		display_feedback "workspace-agent: killed '$target_workspace' and switched clients to '$fallback_workspace'"
	else
		display_feedback "workspace-agent: killed '$target_workspace' (fallback target: '$fallback_workspace')"
	fi
}

prompt_create() {
	tmux_cmd command-prompt -p "Create workspace name:" \
		"run-shell '$0 \"$socket_path\" \"$pane_id\" \"$pane_current_path\" create-input \"%%\" \"\" \"$invoking_client_name\"'"
}

prompt_switch() {
	tmux_cmd command-prompt -p "Switch to workspace:" \
		"run-shell '$0 \"$socket_path\" \"$pane_id\" \"$pane_current_path\" switch-input \"%%\" \"\" \"$invoking_client_name\"'"
}

prompt_rename() {
	local source_workspace
	source_workspace="$(current_session)"
	tmux_cmd command-prompt -I "$source_workspace" -p "Rename workspace (${source_workspace} ->):" \
		"run-shell '$0 \"$socket_path\" \"$pane_id\" \"$pane_current_path\" rename-input \"$source_workspace\" \"%%\" \"$invoking_client_name\"'"
}

show_menu_launcher() {
	tmux_cmd display-menu -t "$pane_id" -T "workspace-agent launcher" \
		"Launch opencode" o "run-shell '$0 \"$socket_path\" \"$pane_id\" \"$pane_current_path\" launch-agent \"opencode\" \"\" \"$invoking_client_name\"'" \
		"Launch codex" d "run-shell '$0 \"$socket_path\" \"$pane_id\" \"$pane_current_path\" launch-agent \"codex\" \"\" \"$invoking_client_name\"'" \
		"Launch droid" i "run-shell '$0 \"$socket_path\" \"$pane_id\" \"$pane_current_path\" launch-agent \"droid\" \"\" \"$invoking_client_name\"'" \
		"Launch pi" p "run-shell '$0 \"$socket_path\" \"$pane_id\" \"$pane_current_path\" launch-agent \"pi\" \"\" \"$invoking_client_name\"'" \
		"" "" "" \
		"Create workspace" c "run-shell '$0 \"$socket_path\" \"$pane_id\" \"$pane_current_path\" create-prompt \"\" \"\" \"$invoking_client_name\"'" \
		"Switch workspace" s "run-shell '$0 \"$socket_path\" \"$pane_id\" \"$pane_current_path\" switch-prompt \"\" \"\" \"$invoking_client_name\"'" \
		"Rename workspace" r "run-shell '$0 \"$socket_path\" \"$pane_id\" \"$pane_current_path\" rename-prompt \"\" \"\" \"$invoking_client_name\"'" \
		"Kill workspace" x "run-shell '$0 \"$socket_path\" \"$pane_id\" \"$pane_current_path\" kill-prompt \"\" \"\" \"$invoking_client_name\"'" \
		"" "" "" \
		"Exit launcher" q ""
}

popup_ui_launcher() {
	local selected_action

	if ! command -v fzf >/dev/null 2>&1; then
		display_feedback "workspace-agent: popup launcher unavailable (missing fzf), using menu fallback"
		return 1
	fi

	selected_action="$(list_picker_entries | fzf --prompt='workspace action> ' --height=100% --layout=reverse --border --exit-0 || true)"

	case "$selected_action" in
	agent:*)
		launch_agent "${selected_action#agent:}"
		;;
	create)
		prompt_create
		;;
	switch)
		prompt_switch
		;;
	rename)
		prompt_rename
		;;
	kill)
		prompt_kill_workspace
		;;
	exit | "")
		display_feedback "workspace-agent: picker canceled"
		;;
	*)
		display_feedback "workspace-agent: popup selection '$selected_action' is unsupported"
		return 1
		;;
	esac
}

show_launcher() {
	local popup_mode

	popup_mode="$(tmux_cmd show-option -gqv '@workspace_agent_popup_mode')"

	if [ "$popup_mode" != "0" ]; then
		if tmux_cmd display-popup -t "$pane_id" -E "$0 \"$socket_path\" \"$pane_id\" \"$pane_current_path\" popup-ui"; then
			return 0
		fi
	fi

	show_menu_launcher
}

case "$action" in
menu | show-menu | "")
	show_launcher
	;;
list-actions)
	list_actions
	;;
list-agents)
	list_agents
	;;
launch-agent)
	launch_agent "$arg1"
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
popup-ui)
	popup_ui_launcher
	;;
kill-prompt)
	prompt_kill_workspace
	;;
kill-confirm-prompt)
	prompt_kill_confirmation "$arg1"
	;;
kill | kill-input | kill-confirm)
	kill_workspace "$arg1" "$arg2"
	;;
kill-fallback)
	deterministic_fallback_workspace "$arg1"
	;;
*)
	echo "workspace-agent: unknown launcher action '$action'" >&2
	exit 1
	;;
esac
