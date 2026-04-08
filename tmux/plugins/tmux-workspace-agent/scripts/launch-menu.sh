#!/usr/bin/env bash
set -euo pipefail

socket_path="${1:-}"
pane_id="${2:-}"
pane_current_path="${3:-}"

if [ -z "$socket_path" ] || [ -z "$pane_id" ]; then
	echo "workspace-agent: launcher context is missing" >&2
	exit 1
fi

tmux display-message -t "$pane_id" "workspace-agent: launcher scaffold is ready (path: ${pane_current_path:-unknown})"
