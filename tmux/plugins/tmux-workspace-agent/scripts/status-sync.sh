#!/usr/bin/env bash
set -euo pipefail

socket_path="${1:-}"
pane_id="${2:-}"
pane_current_path="${3:-}"
requested_status="${4:-}"
requested_agent="${5:-}"
requested_workspace="${6:-}"

trim() {
	local value="$1"
	value="${value#"${value%%[![:space:]]*}"}"
	value="${value%"${value##*[![:space:]]}"}"
	printf '%s' "$value"
}

if [ -z "$socket_path" ]; then
	echo "workspace-agent: status sync missing socket path" >&2
	exit 1
fi

tmux_cmd() {
	tmux -S "$socket_path" "$@"
}

set_tmux_option_if_changed() {
	local key="$1"
	local new_value="$2"
	local current_value

	current_value="$(tmux_cmd show-option -gqv "$key" 2>/dev/null || true)"
	if [ "$current_value" = "$new_value" ]; then
		return 0
	fi

	tmux_cmd set-option -gq "$key" "$new_value"
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

load_state_snapshot() {
	local file_path="$1"
	[ -f "$file_path" ] || return 0

	bash -c 'set -euo pipefail; source "$1"; printf "%s|%s|%s|%s" "${last_agent:-}" "${last_workspace:-}" "${last_status:-}" "${last_path:-}"' _ "$file_path" 2>/dev/null || true
}

persist_state() {
	local agent="$1"
	local workspace="$2"
	local status="$3"
	local path="$4"
	local state_dir
	local state_file
	local temp_file

	state_dir="$(workspace_agent_state_dir)"
	state_file="$(state_file_path)"

	mkdir -p "$state_dir"
	temp_file="$(mktemp "${state_dir}/state.env.XXXXXX")"
	{
		printf 'last_agent=%q\n' "$agent"
		printf 'last_workspace=%q\n' "$workspace"
		printf 'last_status=%q\n' "$status"
		printf 'last_path=%q\n' "$path"
	} >"$temp_file"

	mv "$temp_file" "$state_file"
}

ensure_status_segment_binding() {
	local status_right
	local segment_token

	status_right="$(tmux_cmd show-option -gqv status-right 2>/dev/null || true)"
	segment_token='#{@workspace_agent_status_segment}'

	case "$status_right" in
	*"$segment_token"*)
		return 0
		;;
	esac

	if [ -n "$status_right" ]; then
		tmux_cmd set-option -gq status-right "${status_right} ${segment_token}"
	else
		tmux_cmd set-option -gq status-right "$segment_token"
	fi
}

resolve_script_path() {
	local plugin_dir="$1"
	local script_name="$2"

	if [ -n "$plugin_dir" ] && [ -x "$plugin_dir/scripts/$script_name" ]; then
		printf '%s/scripts/%s' "$plugin_dir" "$script_name"
	fi
}

pane_id="$(trim "$pane_id")"
if [ -z "$pane_id" ]; then
	pane_id="$(tmux_cmd display-message -p '#{pane_id}' 2>/dev/null || true)"
fi
if [ -z "$pane_id" ]; then
	pane_id="$(tmux_cmd list-panes -a -F '#{pane_id}' 2>/dev/null | awk 'NR == 1 { print; exit }')"
fi

state_snapshot="$(load_state_snapshot "$(state_file_path)")"
state_last_agent=""
state_last_workspace=""
state_last_status=""
state_last_path=""
if [ -n "$state_snapshot" ]; then
	IFS='|' read -r state_last_agent state_last_workspace state_last_status state_last_path <<EOF
$state_snapshot
EOF
fi

option_last_agent="$(tmux_cmd show-option -gqv '@workspace_agent_last_agent' 2>/dev/null || true)"
option_last_workspace="$(tmux_cmd show-option -gqv '@workspace_agent_last_workspace' 2>/dev/null || true)"
option_last_status="$(tmux_cmd show-option -gqv '@workspace_agent_last_status' 2>/dev/null || true)"
option_last_path="$(tmux_cmd show-option -gqv '@workspace_agent_last_path' 2>/dev/null || true)"

resolved_agent="$(trim "$requested_agent")"
if [ -z "$resolved_agent" ]; then
	resolved_agent="$(trim "$option_last_agent")"
fi
if [ -z "$resolved_agent" ]; then
	resolved_agent="$(trim "$state_last_agent")"
fi

resolved_workspace="$(trim "$requested_workspace")"
if [ -z "$resolved_workspace" ] && [ -n "$pane_id" ]; then
	resolved_workspace="$(tmux_cmd display-message -p -t "$pane_id" '#{session_name}' 2>/dev/null || true)"
fi
if [ -z "$resolved_workspace" ]; then
	resolved_workspace="$(trim "$option_last_workspace")"
fi
if [ -z "$resolved_workspace" ]; then
	resolved_workspace="$(trim "$state_last_workspace")"
fi

resolved_status="$(trim "$requested_status")"
if [ -z "$resolved_status" ]; then
	resolved_status="$(trim "$option_last_status")"
fi
if [ -z "$resolved_status" ]; then
	resolved_status="$(trim "$state_last_status")"
fi
if [ -z "$resolved_status" ]; then
	resolved_status="idle"
fi

resolved_path="$(trim "$pane_current_path")"
if [ -z "$resolved_path" ] && [ -n "$pane_id" ]; then
	resolved_path="$(tmux_cmd display-message -p -t "$pane_id" '#{pane_current_path}' 2>/dev/null || true)"
fi
if [ -z "$resolved_path" ]; then
	resolved_path="$(trim "$option_last_path")"
fi
if [ -z "$resolved_path" ]; then
	resolved_path="$(trim "$state_last_path")"
fi
if [ -z "$resolved_path" ]; then
	resolved_path="$HOME"
fi

persist_state "$resolved_agent" "$resolved_workspace" "$resolved_status" "$resolved_path"

set_tmux_option_if_changed '@workspace_agent_last_agent' "$resolved_agent"
set_tmux_option_if_changed '@workspace_agent_last_workspace' "$resolved_workspace"
set_tmux_option_if_changed '@workspace_agent_last_status' "$resolved_status"
set_tmux_option_if_changed '@workspace_agent_last_path' "$resolved_path"
ensure_status_segment_binding

bridge_value="$(tmux_cmd show-option -gqv '@workspace_agent_bridge' 2>/dev/null || true)"
bridge_enabled='0'
if [ "$bridge_value" = "1" ]; then
	bridge_enabled='1'
fi

workspace_sidebar_dir="$(tmux_cmd show-option -gqv '@workspace_sidebar_plugin_dir' 2>/dev/null || true)"
window_name_lite_dir="$(tmux_cmd show-option -gqv '@window_name_lite_plugin_dir' 2>/dev/null || true)"

sidebar_update_script="$(resolve_script_path "$workspace_sidebar_dir" "update-state.sh")"
window_refresh_script="$(resolve_script_path "$window_name_lite_dir" "refresh.sh")"

if [ "$bridge_enabled" = "1" ]; then
	if [ -n "$sidebar_update_script" ] && [ -n "$pane_id" ]; then
		"$sidebar_update_script" \
			--socket-path "$socket_path" \
			--pane "$pane_id" \
			--app "workspace-agent" \
			--status "$resolved_status" \
			--message "workspace=$resolved_workspace agent=$resolved_agent" >/dev/null 2>&1 || true
	fi
	set_tmux_option_if_changed '@workspace_agent_bridge_state' "bridge"
else
	if [ -n "$sidebar_update_script" ] && [ -n "$pane_id" ]; then
		"$sidebar_update_script" \
			--socket-path "$socket_path" \
			--pane "$pane_id" \
			--app "workspace-agent" \
			--status "" \
			--message "" >/dev/null 2>&1 || true
	fi
	set_tmux_option_if_changed '@workspace_agent_bridge_state' "standalone"
fi

if [ -n "$window_refresh_script" ] && [ -n "$pane_id" ]; then
	window_id="$(tmux_cmd display-message -p -t "$pane_id" '#{window_id}' 2>/dev/null || true)"
	if [ -n "$window_id" ]; then
		"$window_refresh_script" "$socket_path" "$window_id" >/dev/null 2>&1 || true
	fi
fi

segment_workspace="$resolved_workspace"
segment_agent="$resolved_agent"
segment_status="$resolved_status"

[ -n "$segment_workspace" ] || segment_workspace='none'
[ -n "$segment_agent" ] || segment_agent='none'
[ -n "$segment_status" ] || segment_status='idle'

segment="[wa:${segment_workspace}:${segment_agent}:${segment_status}]"
if [ "$bridge_enabled" = "1" ]; then
	segment="[wa:${segment_workspace}:${segment_agent}:${segment_status}:bridge]"
fi

set_tmux_option_if_changed '@workspace_agent_status_segment' "$segment"
