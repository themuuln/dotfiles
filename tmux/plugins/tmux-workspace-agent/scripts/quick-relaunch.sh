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

state_file="${WORKSPACE_AGENT_STATE_DIR:-${XDG_STATE_HOME:-$HOME/.local/state}/tmux-workspace-agent}/state.env"
last_agent="$(tmux_cmd show-option -gqv '@workspace_agent_last_agent' 2>/dev/null || true)"

if [ -z "$last_agent" ] && [ -f "$state_file" ]; then
	last_agent="$(bash -c 'set -euo pipefail; source "$1"; printf "%s" "${last_agent:-}"' _ "$state_file" 2>/dev/null || true)"
fi

if [ -z "$last_agent" ]; then
	tmux_cmd display-message -t "$pane_id" "workspace-agent: no last-agent history yet"
	exit 0
fi

"$AGENT_LAUNCH_SCRIPT" "$socket_path" "$pane_id" "$pane_current_path" "$last_agent"
