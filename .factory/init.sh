#!/usr/bin/env bash
set -euo pipefail

mkdir -p /Users/ict/.config/tmux/plugins/tmux-workspace-agent/scripts
mkdir -p /Users/ict/.config/tmux/plugins/tmux-workspace-agent/state
mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/tmux-workspace-agent"

command -v tmux >/dev/null
command -v bash >/dev/null
command -v fzf >/dev/null
