# User Testing

Guidance for user-testing validators on this mission.

## Validation Surface

- Primary surface: terminal/tmux workflows.
- Scope under test:
  - `Prefix+g` namespace and action menu (`a`)
  - quick relaunch (`A`)
  - workspace actions (create/switch/rename/kill)
  - agent CLI launch/relaunch (`opencode`, `codex`, `droid`, `pi`)
  - standalone + optional bridge status behavior

## Required Tools

- `tmux` CLI on isolated sockets (`tmux -L <socket> ...`)
- `tuistory` for interactive key-path evidence when required by assertions

## Isolation Rules

- Always use dedicated socket names per flow/assertion group.
- Never run assertions against live/default tmux socket.
- Kill each test socket server after checks (`tmux -L <socket> kill-server`).

## Validation Concurrency

- Surface classification: **low resource cost** (tmux CLI + short-lived shells).
- Machine profile observed during dry run:
  - CPU: 8 logical
  - Memory: 16 GiB
- Recommended max concurrent validators for this surface: **5**
- Rationale: dry run showed small per-validator footprint; 5 remains within 70% headroom budget.

## Evidence Expectations

- Pre-state snapshot
- Action trace (exact command/key sequence)
- Post-state snapshot
- Failure/cancel branch feedback artifact where applicable

## Flow Validator Guidance: tmux-cli

- Use only isolated sockets with explicit names (for example `tmux -L utv_foundation_key ...`).
- Never run mutating commands without `-L <socket>`.
- Keep all validation actions scoped to:
  - `/Users/ict/.config/tmux/plugins/tmux-workspace-agent/**`
  - `/Users/ict/.config/tmux/tmux.conf`
  - mission evidence/report paths
- Do not read/write unrelated config trees or live tmux socket state.
- Cleanup every created test socket with `tmux -L <socket> kill-server`.
