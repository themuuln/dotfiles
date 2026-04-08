#!/usr/bin/env bash
set -euo pipefail

socket_path="${1:-}"
pane_id="${2:-}"
pane_current_path="${3:-}"
last_agent="$(tmux show-option -gqv '@workspace_agent_last_agent')"

if [ -z "$socket_path" ] || [ -z "$pane_id" ]; then
	echo "workspace-agent: quick relaunch context is missing" >&2
	exit 1
fi

if [ -z "$last_agent" ]; then
	tmux display-message -t "$pane_id" "workspace-agent: no last-agent history yet"
	exit 0
fi

tmux display-message -t "$pane_id" "workspace-agent: relaunch scaffold for ${last_agent} (path: ${pane_current_path:-unknown})"
