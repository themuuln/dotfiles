# Environment

Environment variables, external dependencies, and setup notes for this mission.

## Dependencies

- `tmux` (validated available, version 3.6a in current environment)
- `bash`
- `fzf`
- Agent CLIs in PATH:
  - `opencode`
  - `codex`
  - `droid`
  - `pi`

## State Paths

- Plugin local runtime state:
  - `${XDG_STATE_HOME:-$HOME/.local/state}/tmux-workspace-agent/`
- Mission implementation path:
  - `/Users/ict/.config/tmux/plugins/tmux-workspace-agent/`

## Notes

- No external API keys, credentials, databases, or network services are required.
- No service ports are used in this mission.
- If a CLI is missing from PATH during validation, expected behavior is graceful feedback and no state corruption.
