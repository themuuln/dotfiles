# tmux repo plugin audit (2026-04-08)

## Current state summary

- Primary config is `tmux/tmux.conf`; active plugin loading there is:
  - TPM + standard plugins (`tmux-sensible`, `vim-tmux-navigator`, `tmux-resurrect`, `tmux-continuum`, `tokyo-night-tmux`)
  - Custom local plugin: `run-shell '~/.config/tmux/plugins/tmux-window-name-lite/window-name-lite.tmux'`
  - `tmux-workspace-sidebar` and `tmux-session-manager` are currently **not enabled** in `tmux.conf` (commented).
- `tmux/tmux.reset.conf` is a sidebar-oriented variant that does run `tmux-workspace-sidebar/sidebar.tmux` and swaps `S-Left/S-Right` to `scripts/cycle-window.sh`.
- Existing custom tmux plugin directories are present under `tmux/plugins/`, including:
  - `tmux-workspace-sidebar` (custom, rich sidebar + actionable state system)
  - `tmux-window-name-lite` (custom window auto-naming + status suffix from sidebar state)
  - `tmux-session-manager` (3rd-party fzf popup session switcher)
  - `tmux-which-key` (3rd-party prefix-space menu system, currently not loaded)

## Reusable components

### 1) `tmux-workspace-sidebar` as backend primitives

- `scripts/update-state.sh` already provides generic per-pane state writing (`--app`, `--status`, `--message`) and signaling.
- `scripts/switch-session.sh` and `scripts/cycle-window.sh` already implement stable navigation behavior tied to sidebar ordering/sorting.
- `tmux_workspace_sidebar/apps.py` has provider architecture (`AppProvider`, `PROVIDERS`) that can be extended for additional agent CLIs.
- `tmux_workspace_sidebar/sidebar_actions.py` has reusable launch-command wrapping (`build_codex_launch_command`) and window creation pattern.

### 2) `tmux-window-name-lite` as UX layer for quick identity

- Supports command-based labeling via:
  - `@window_name_lite_factory_droid_commands`
  - `@window_name_lite_pi_commands`
- Reads sidebar state files and can append status suffixes (`:running`, `:done`, etc.), so a new agent plugin can piggyback on this without inventing a new status display path.

### 3) Existing UX conventions in `tmux.conf`

- Heavy use of popup-based workflows (`display-popup`) and simple `run-shell` entrypoints.
- Namespaced options pattern already established: `@workspace_sidebar_*`, `@window_name_lite_*`.

## Conflicts to avoid

## Keybinding conflicts

- `prefix + j` is already used by pane navigation in `tmux.conf`; enabling `tmux-session-manager` default bind (`j`) would conflict.
- `prefix + Space` is claimed by `tmux-which-key` when loaded; avoid using it in a new plugin.
- If `tmux-workspace-sidebar` is enabled, it binds:
  - `prefix + B`, `b`, `m`, `M`, `u`
  - optional global `-n` session keys via `@workspace_sidebar_session_keys`
- Existing config already binds many letters (`r`, `R`, `w`, `s`, `v`, `h/j/k/l`, etc.); pick unused keys for the new plugin (practical safe candidates: `prefix + a` and `prefix + A`).

## Hook conflicts (important)

- `tmux-workspace-sidebar/sidebar.tmux` uses `tmux set-hook -g ...`
- `tmux-window-name-lite/window-name-lite.tmux` also uses `tmux set-hook -g ...` on overlapping hooks (`after-new-window`, `after-split-window`, `after-select-pane`, `after-select-window`, `client-session-changed`).
- Because `set-hook -g` overwrites, load order decides winner; the later plugin can silently disable earlier hook behavior.
- New plugin should avoid direct overwrites; use append-style hook chaining or a dispatcher pattern.

## Agent identity conflicts

- Current `tmux.conf` sets `@window_name_lite_pi_commands 'pi,pi-coding-agent,codex'`; this makes `codex` panes appear as `pi`.
- For a plugin that distinguishes `opencode/codex/droid/pi`, keep command mapping unambiguous (do not group `codex` under `pi` unless intentional).

## Proposed plugin layout

Recommended concrete path:

- `/Users/ict/.config/tmux/plugins/tmux-workspace-agent/`

Suggested structure:

```text
tmux/plugins/tmux-workspace-agent/
  workspace-agent.tmux
  scripts/
    helpers.sh
    open-menu.sh
    launch-agent.sh
    launch-workspace.sh
    update-agent-state.sh
```

Design notes:

- Use namespaced tmux options: `@workspace_agent_*`
- Reuse sidebar state pipeline by delegating status writes to:
  - `~/.config/tmux/plugins/tmux-workspace-sidebar/scripts/update-state.sh`
- Keep keybind surface small (easy UX):
  - `prefix + a`: open agent/workspace menu popup
  - `prefix + A`: relaunch last-used agent in current path
- Launch CLIs with explicit command map:
  - `opencode`, `codex`, `droid`, `pi`

## Wiring into `tmux.conf` (recommended)

Place near existing custom plugin block (before TPM init):

```tmux
# workspace agent plugin
set -g @workspace_agent_menu_key 'a'
set -g @workspace_agent_quick_key 'A'
set -g @workspace_agent_clis 'opencode,codex,droid,pi'
run-shell '~/.config/tmux/plugins/tmux-workspace-agent/workspace-agent.tmux'
```

If sidebar integration is desired in the same runtime, ensure hook-safe chaining to avoid disabling `window-name-lite` refresh hooks.

## Minimal migration plan

1. Create plugin scaffold at `tmux/plugins/tmux-workspace-agent/` with namespaced options and two keybindings (`a`, `A`).
2. Implement launch flows for `opencode/codex/droid/pi` using popup-driven selection and current pane path default.
3. Integrate status updates by calling existing `tmux-workspace-sidebar/scripts/update-state.sh` (no new state format).
4. Resolve command-label mapping so codex and pi are distinct (adjust `@window_name_lite_*_commands` behavior or plugin launch titles accordingly).
5. Add `run-shell '~/.config/tmux/plugins/tmux-workspace-agent/workspace-agent.tmux'` to `tmux/tmux.conf`.
6. Validate key/hook coexistence with:
   - `tmux-window-name-lite` loaded
   - optional `tmux-workspace-sidebar` enabled
   - no regression in `S-Left/S-Right`, popup workflows, and window naming refresh.
