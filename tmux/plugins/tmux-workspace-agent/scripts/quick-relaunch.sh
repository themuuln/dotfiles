#!/usr/bin/env bash
set -euo pipefail

socket_path="${1:-}"
pane_id="${2:-}"
pane_current_path="${3:-}"
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_LAUNCH_SCRIPT="$CURRENT_DIR/agent-launch.sh"

if [ -z "$socket_path" ] || [ -z "$pane_id" ]; then
	echo "workspace-agent: quick relaunch context is missing" >&2
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
	local candidate="$1"
	local configured_agent

	while IFS= read -r configured_agent; do
		[ -n "$configured_agent" ] || continue
		if [ "$configured_agent" = "$candidate" ]; then
			return 0
		fi
	done < <(list_configured_agents)

	return 1
}

state_file="${WORKSPACE_AGENT_STATE_DIR:-${XDG_STATE_HOME:-$HOME/.local/state}/tmux-workspace-agent}/state.env"
last_agent="$(tmux_cmd show-option -gqv '@workspace_agent_last_agent' 2>/dev/null || true)"

if [ -z "$last_agent" ] && [ -f "$state_file" ]; then
	last_agent="$(bash -c 'set -euo pipefail; source "$1"; printf "%s" "${last_agent:-}"' _ "$state_file" 2>/dev/null || true)"
fi

if [ -z "$last_agent" ]; then
	display_feedback "workspace-agent: no last-agent history yet"
	exit 0
fi

if ! agent_is_configured "$last_agent"; then
	display_feedback "workspace-agent: last-agent history '$last_agent' is no longer configured"
	exit 0
fi

if ! command -v "$last_agent" >/dev/null 2>&1; then
	display_feedback "workspace-agent: last-agent history '$last_agent' is unavailable in PATH"
	exit 0
fi

if ! "$AGENT_LAUNCH_SCRIPT" "$socket_path" "$pane_id" "$pane_current_path" "$last_agent"; then
	display_feedback "workspace-agent: quick relaunch failed for '$last_agent'"
	exit 0
fi
