#!/usr/bin/env bash
set -euo pipefail

socket_path="${1:-}"
segment_token='#{@workspace_agent_status_segment}'

if [ -z "$socket_path" ]; then
	echo "workspace-agent: ensure-status-right missing socket path" >&2
	exit 1
fi

tmux_cmd() {
	tmux -S "$socket_path" "$@"
}

status_right="$(tmux_cmd show-option -gqv status-right 2>/dev/null || true)"

case "$status_right" in
*"$segment_token"*)
	exit 0
	;;
esac

if [ -n "$status_right" ]; then
	tmux_cmd set-option -gq status-right "${status_right} ${segment_token}"
else
	tmux_cmd set-option -gq status-right "$segment_token"
fi
