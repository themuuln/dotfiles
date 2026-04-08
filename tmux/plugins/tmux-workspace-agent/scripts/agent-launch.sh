#!/usr/bin/env bash
set -euo pipefail

socket_path="${1:-}"
pane_id="${2:-}"
pane_current_path="${3:-}"
requested_agent="${4:-}"
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATUS_SYNC_SCRIPT="$CURRENT_DIR/status-sync.sh"

if [ -z "$socket_path" ] || [ -z "$pane_id" ]; then
	echo "workspace-agent: agent launch context is missing" >&2
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

	return 0
}

trim() {
	local value="$1"
	value="${value#"${value%%[![:space:]]*}"}"
	value="${value%"${value##*[![:space:]]}"}"
	printf '%s' "$value"
}

single_quote_escape() {
	local value="$1"
	printf "%s" "$value" | sed "s/'/'\"'\"'/g"
}

shell_quote() {
	local value="$1"
	printf "'%s'" "$(single_quote_escape "$value")"
}

list_configured_agents() {
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

agent_is_configured() {
	local requested="$1"
	local configured_agent

	while IFS= read -r configured_agent; do
		[ -n "$configured_agent" ] || continue
		if [ "$configured_agent" = "$requested" ]; then
			return 0
		fi
	done < <(list_configured_agents)

	return 1
}

workspace_agent_state_dir() {
	if [ -n "${WORKSPACE_AGENT_STATE_DIR:-}" ]; then
		printf '%s' "$WORKSPACE_AGENT_STATE_DIR"
	else
		printf '%s/tmux-workspace-agent' "${XDG_STATE_HOME:-$HOME/.local/state}"
	fi
}

state_file_path() {
	printf '%s/state.env' "$(workspace_agent_state_dir)"
}

persist_launch_state() {
	local agent="$1"
	local current_path="$2"
	local state_dir
	local state_file
	local temp_file
	local last_workspace

	state_dir="$(workspace_agent_state_dir)"
	state_file="$(state_file_path)"
	last_workspace="$(tmux_cmd display-message -p -t "$pane_id" '#{session_name}' 2>/dev/null || true)"

	mkdir -p "$state_dir"
	temp_file="$(mktemp "${state_dir}/state.env.XXXXXX")"
	{
		printf 'last_agent=%q\n' "$agent"
		printf 'last_workspace=%q\n' "${last_workspace:-}"
		printf 'last_status=%q\n' "running"
		printf 'last_path=%q\n' "$current_path"
	} >"$temp_file"

	mv "$temp_file" "$state_file"
}

launch_agent() {
	local agent_name="$1"
	local agent_binary
	local launch_path
	local launch_command

	agent_name="$(trim "$agent_name")"
	if [ -z "$agent_name" ]; then
		display_feedback "workspace-agent: picker canceled"
		return 0
	fi

	if ! agent_is_configured "$agent_name"; then
		display_feedback "workspace-agent: unsupported agent '$agent_name'"
		return 1
	fi

	agent_binary="$(command -v "$agent_name" || true)"
	if [ -z "$agent_binary" ]; then
		display_feedback "workspace-agent: '$agent_name' is unavailable in PATH"
		return 1
	fi

	launch_path="$(trim "${pane_current_path:-}")"
	if [ -z "$launch_path" ]; then
		launch_path="$(tmux_cmd display-message -p -t "$pane_id" '#{pane_current_path}' 2>/dev/null || true)"
	fi
	if [ -z "$launch_path" ]; then
		launch_path="$HOME"
	fi

	launch_command="cd $(shell_quote "$launch_path") && $(shell_quote "$agent_binary")"
	tmux_cmd send-keys -t "$pane_id" "$launch_command" Enter

	tmux_cmd set-option -gq '@workspace_agent_last_agent' "$agent_name"
	persist_launch_state "$agent_name" "$launch_path"
	if [ -x "$STATUS_SYNC_SCRIPT" ]; then
		"$STATUS_SYNC_SCRIPT" "$socket_path" "$pane_id" "$launch_path" "running" "$agent_name" "" >/dev/null 2>&1 || true
	fi
	display_feedback "workspace-agent: launched '$agent_name' from '$launch_path'"
}

launch_agent "$requested_agent"
