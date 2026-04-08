# Architecture

This mission adds a tmux-native plugin layer that provides cmux-inspired workspace UX and agent-launch workflows while preserving compatibility with existing local tmux plugins.

## Canonical Domain Mapping

- `workspace` == **tmux session** (single source of truth).
- Workspace actions map to tmux session operations:
  - create -> `new-session -d -s <name>`
  - switch -> `switch-client -t <session>`
  - rename -> `rename-session -t <old> <new>`
  - kill -> `kill-session -t <session>` (guarded by explicit confirmation flow)

## Core Components

1. `tmux/plugins/tmux-workspace-agent/workspace-agent.tmux`
   - Plugin entrypoint loaded from `tmux.conf`.
   - Registers `@workspace_agent_*` options and key-table wiring rooted at `Prefix+g`.
   - Must be reload-safe and idempotent.

2. `tmux/plugins/tmux-workspace-agent/scripts/*`
   - Shell scripts that implement launcher actions and agent command execution.
   - Separate responsibilities:
     - action menu orchestration
     - workspace create/switch/rename/kill handlers
     - agent launch / quick relaunch
     - local state read/write
     - optional bridge writes for existing integrations

3. tmux key architecture
   - Entrypoint: `Prefix+g`.
   - Expected binding model:
     - `bind-key g switch-client -T workspace_agent`
     - `bind-key -T workspace_agent a run-shell '<...>/launch-menu.sh'`
     - `bind-key -T workspace_agent A run-shell '<...>/quick-relaunch.sh'`
     - `bind-key -T workspace_agent q switch-client -T prefix` and/or `Escape` exit.
   - Key behavior is scoped to namespace tables and should not introduce unintended global remaps.

4. State model
   - Plugin-local state stores minimal runtime context (last agent, active workspace metadata, status).
   - State location:
     - `${XDG_STATE_HOME:-$HOME/.local/state}/tmux-workspace-agent/`
   - Required files:
     - `state.env` (shell-safe `key=value` entries)
     - optional `events.log` (append-only troubleshooting signal)
   - Required keys in `state.env`:
     - `last_agent`, `last_workspace`, `last_status`, `last_path`
   - Writes must be atomic (`mktemp` + `mv`) and reads must tolerate missing files.
   - Optional bridge mode writes compatible state/events used by existing `tmux-workspace-sidebar` / `tmux-window-name-lite` behaviors.
   - Bridge off must still provide complete standalone UX.

## Data / Control Flows

1. **User input flow**
   - User presses `Prefix+g` -> namespace table.
   - User chooses action (`a`, `A`, workspace operation).
   - Script executes tmux commands and updates state.

2. **Agent launch flow**
   - Launcher resolves selected CLI (`opencode`, `codex`, `droid`, `pi`).
   - Command runs from caller pane working directory.
   - Success updates last-agent state; failure reports feedback without unsafe state mutation.

3. **Bridge flow (optional)**
   - Bridge toggle option: `@workspace_agent_bridge` (`0` default, `1` enabled).
   - When enabled, plugin emits bridge-compatible updates after workspace/agent events.
   - Target compatibility contracts:
     - Sidebar pipeline (`tmux-workspace-sidebar`) update hook/state path integration.
     - Window name pipeline (`tmux-window-name-lite`) suffix/status compatibility.
   - Existing plugin behavior (window naming/sidebar) should remain additive and non-destructive.
   - Missing optional integrations must result in no-op fallback, never fatal errors.

4. **Reload flow**
   - `source-file` may run repeatedly.
   - Hooks/key bindings/status insertion must remain stable and non-duplicating.

## Invariants

- All automated validation and development checks use isolated tmux sockets (`tmux -L <socket>`).
- Live/default tmux socket must not be modified by mission verification.
- `Prefix+g` remains the plugin root interaction contract.
- Quick relaunch uses the stored last agent and caller pane current path.
- Standalone mode works with no optional integration dependencies.
- Bridge mode does not clobber unrelated user options/status segments.

## Launcher / Execution Semantics

- `a` (menu):
  - Primary surface: popup menu/picker.
  - Fallback surface: non-popup tmux menu/chooser when popup unavailable.
  - Agent launch runs in current pane context by default.
- `A` (quick relaunch):
  - Uses `last_agent` from state.
  - Executes from current pane path at invocation time.
  - If no usable history, shows feedback and performs no launch.

## Validation Gate (Executable)

Minimum gate for worker completion and validator checks:

1. `bash -n tmux/plugins/tmux-workspace-agent/workspace-agent.tmux`
2. `bash -n tmux/plugins/tmux-workspace-agent/scripts/*.sh`
3. `tmux -L <socket> -f /Users/ict/.config/tmux/tmux.conf new-session -d -s <session>`
4. `tmux -L <socket> source-file /Users/ict/.config/tmux/tmux.conf`
5. `tmux -L <socket> list-keys -T prefix` and `list-keys -T workspace_agent` assertions
6. Launcher and relaunch smoke flow in isolated socket
7. `tmux -L <socket> kill-server`

## Boundaries

- Only mutate files in tmux plugin/config scope requested by mission.
- No external services, ports, or credentials required.
- No dependency on remote APIs for core behavior.
