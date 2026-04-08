# tmux Workspace UX Research (2026-04-08)

## Sources

- cmux Concepts (hierarchy model): https://www.cmux.dev/docs/concepts
- cmux Getting Started (workspace/sidebar + notifications framing): https://www.cmux.dev/docs/getting-started
- cmux Keyboard Shortcuts (navigation + quick actions): https://www.cmux.dev/docs/keyboard-shortcuts
- cmux API (CLI/socket control for workspace automation): https://www.cmux.dev/docs/api
- cmux Custom Commands (project-scoped actions/layouts): https://www.cmux.dev/docs/custom-commands
- cmux Changelog (recent UX/status changes): https://www.cmux.dev/docs/changelog
- cmux GitHub README (AI-agent workflow positioning + notification model): https://github.com/manaflow-ai/cmux/blob/main/README.md
- tmux man page (choose-tree / command-prompt / display-menu / display-popup primitives): https://man7.org/linux/man-pages/man1/tmux.1.html
- tmux Advanced Use wiki (interactive/session workflows): https://github.com/tmux/tmux/wiki/Advanced-Use
- tmux CHANGES (3.6/3.6a UX refinements incl. popup/menu behavior): https://raw.githubusercontent.com/tmux/tmux/3.6a/CHANGES
- tmux discoverability pain point discussion (self-documenting mode keys): https://github.com/tmux/tmux/issues/4357
- Zellij session manager alias: https://zellij.dev/documentation/session-manager-alias.html
- Zellij compact bar alias: https://zellij.dev/documentation/compact-bar-alias.html
- Zellij keybindings/modes: https://zellij.dev/documentation/keybindings.html
- Zellij commands/CLI control: https://zellij.dev/documentation/commands.html
- Zellij 0.44 release (remote sessions + automation direction): https://zellij.dev/news/remote-sessions-windows-cli/
- Ghostty keybind system: https://ghostty.org/docs/config/keybind
- Ghostty keybind action reference: https://ghostty.org/docs/config/keybind/reference
- Ghostty 1.2 release (command palette + quick terminal): https://ghostty.org/docs/install/release-notes/1-2-0
- Ghostty 1.3 release (workflow discoverability improvements like scrollback search): https://ghostty.org/docs/install/release-notes/1-3-0
- Ghostty command-palette keyboard UX gap (active issue): https://github.com/ghostty-org/ghostty/issues/10718

## Comparative UX matrix

| UX area | cmux | tmux | zellij | ghostty | Plugin implication |
|---|---|---|---|---|---|
| Workspace/session model | Hierarchical model centered on workspaces and panes, with explicit UI concepts and AI-agent-first organization. (https://www.cmux.dev/docs/concepts, https://www.cmux.dev/docs/getting-started) | Strong session/window/pane core with detach/attach durability. (https://man7.org/linux/man-pages/man1/tmux.1.html) | Session manager is first-class and exposed as an internal plugin alias. (https://zellij.dev/documentation/session-manager-alias.html) | Emulator-first, but supports tabs/splits and command-driven actions. (https://ghostty.org/docs/config/keybind/reference) | Keep tmux-native sessions/windows/panes, but layer a workspace abstraction and session-manager UI on top. |
| Discoverability | Keyboard shortcuts documented and customizable; command-centric UX. (https://www.cmux.dev/docs/keyboard-shortcuts) | Very powerful but discoverability is weaker; community asks for self-documenting chooser modes. (https://github.com/tmux/tmux/issues/4357) | Welcome/session-manager/compact-bar plugins improve affordance and wayfinding. (https://zellij.dev/documentation/session-manager-alias.html, https://zellij.dev/documentation/compact-bar-alias.html) | Command palette introduced for action discovery. (https://ghostty.org/docs/install/release-notes/1-2-0) | Provide “always available” help/hints + searchable action launcher. |
| Quick actions / palette | Command and custom-command model supports project actions and automation. (https://www.cmux.dev/docs/custom-commands, https://www.cmux.dev/docs/api) | `command-prompt`, `display-menu`, `display-popup`, `choose-tree` are excellent primitives but need assembly. (https://man7.org/linux/man-pages/man1/tmux.1.html) | Plugin aliases and CLI actions give coherent quick-action surfaces. (https://zellij.dev/documentation/commands.html) | Palette maps to keybind actions and centralizes non-obvious commands. (https://ghostty.org/docs/install/release-notes/1-2-0) | Build a tmux “universal action launcher” backed by chooser/popup/menu primitives. |
| Keybinding ergonomics | Shortcut-first with workspace/navigation defaults and customization. (https://www.cmux.dev/docs/keyboard-shortcuts) | Prefix + tables are flexible but cognitively heavy for new users. (https://man7.org/linux/man-pages/man1/tmux.1.html) | Mode-based keybindings + explicit keybinding docs reduce collisions. (https://zellij.dev/documentation/keybindings.html) | Rich keybind DSL incl. sequences lowers conflict pressure. (https://ghostty.org/docs/config/keybind/sequence) | Ship opinionated default map, plus optional “beginner” and “vim-like” profiles. |
| Status & attention routing | Notification-focused model (rings/panel + agent-centric updates). (https://www.cmux.dev/docs/getting-started, https://github.com/manaflow-ai/cmux/blob/main/README.md) | Native alerts exist, but workflow-level attention routing is mostly user-config/plugin-defined. (https://man7.org/linux/man-pages/man1/tmux.1.html) | Compact bar and session manager support persistent state cues. (https://zellij.dev/documentation/compact-bar-alias.html) | Palette/search + quick terminal improve transient task flow, less session-state-centric. (https://ghostty.org/docs/install/release-notes/1-3-0) | Prioritize actionable-state sorting/jumping and consistent badges across agents. |

### cmux UX model summary (for direct porting)

- **Workspace-first mental model:** explicit hierarchy (Window → Workspace → Pane → Surface/Panel) encourages “project as workspace” navigation rather than raw pane IDs. (https://www.cmux.dev/docs/concepts)
- **Navigation model:** heavy keyboard operation with direct shortcuts and quick-action flows, with customization support. (https://www.cmux.dev/docs/keyboard-shortcuts)
- **Automation model:** workspace and pane operations are scriptable via CLI + socket API; custom commands bind project context to repeatable actions. (https://www.cmux.dev/docs/api, https://www.cmux.dev/docs/custom-commands)
- **Status model:** AI-agent workflows surfaced through notification-oriented UX (eg. attention rings/panel patterns and agent integration focus). (https://www.cmux.dev/docs/getting-started, https://github.com/manaflow-ai/cmux/blob/main/README.md)

## Recommended tmux plugin UX spec

### 1) Convergent patterns to port

- **Workspace switcher as primary shell:** one searchable overlay for sessions/windows/panes + actions, combining tmux `choose-tree` power with command-palette discoverability. (https://man7.org/linux/man-pages/man1/tmux.1.html, https://ghostty.org/docs/install/release-notes/1-2-0, https://zellij.dev/documentation/session-manager-alias.html)
- **Persistent ambient context:** compact always-visible bar/sidebar for current workspace + actionable counts; deep actions live in overlay. (https://zellij.dev/documentation/compact-bar-alias.html, https://www.cmux.dev/docs/getting-started)
- **Action-first command grammar:** verbs (`switch`, `new`, `move`, `rename`, `kill`, `focus`, `agent`) plus fuzzy target selection. (https://zellij.dev/documentation/commands.html, https://www.cmux.dev/docs/custom-commands)
- **Mode-safe key ergonomics:** default key layer + optional modal profile to avoid collisions and preserve muscle memory. (https://zellij.dev/documentation/keybindings.html, https://man7.org/linux/man-pages/man1/tmux.1.html)
- **Attention routing:** unread/actionable-first ordering and jump-next-action workflows. (https://www.cmux.dev/docs/changelog, https://www.cmux.dev/docs/getting-started)

### 2) Opinionated defaults for onboarding

- **Single “home key”:** `prefix + Space` opens action launcher (switch/create/rename/kill/open-agent/help).
- **Two-tier navigation:**  
  - Tier 1 quick jump: `prefix + 1..9` to top workspaces (recent/actionable weighted).  
  - Tier 2 fuzzy: launcher search for everything.
- **Beginner hint rail:** first 7 days (or first 30 launches), show bottom hints for next likely action; disable automatically after confidence threshold.
- **Safe destructive actions:** require second keypress for kill operations (`x` then `x`) unless `expert_mode=1`.
- **Readable status defaults:** fixed state set `idle | running | needs-input | done-unseen | error` with color + symbol redundancy.
- **Profile presets:** `minimal`, `agent-heavy`, `vim-ergonomic`; default = `agent-heavy`.

### 3) Minimal interaction spec

- **Launcher sections:** `Workspaces`, `Panes`, `Agents`, `Recent`, `Commands`.
- **Universal object preview:** right panel shows cwd, command, last event, status, and last activity time.
- **No dead-end overlays:** every modal includes `?` inline key help and `Esc` escape path.
- **Fallback behavior:** if popup not supported, degrade to sidebar/pane UI without feature loss.

## Agent CLI integration UX defaults

Target CLIs: **opencode, codex, droid, pi**.

### Adapter contract (uniform across CLIs)

- **Canonical status events:** `session_start`, `task_start`, `needs_input`, `task_done`, `task_error`, `idle`.
- **Transport priority:** structured hooks > JSON logs > stdout pattern fallback.  
  (Pattern inspired by cmux custom integrations/API and Zellij CLI automation direction: https://www.cmux.dev/docs/api, https://www.cmux.dev/docs/custom-commands, https://zellij.dev/news/remote-sessions-windows-cli/)
- **Per-pane identity:** `{agent, workspace, pane_id, cwd, task_id}` persisted to local state.

### UX defaults in tmux

- **Agent lane in launcher:** quick filters `@needs-input`, `@errors`, `@running`, `@done-unseen`.
- **Actionable inbox keys:**  
  - `prefix + m` = jump oldest actionable  
  - `prefix + M` = jump next actionable  
  - `prefix + u` = open actionable picker
- **Seen semantics:** entering a pane clears `done-unseen` to `idle` but keeps history in activity log view.
- **Autospawn templates:**  
  - `New Workspace (4-pane agent preset)` = shell + agent + tests + logs  
  - optional per-agent command templates (`codex`, `droid`, `opencode`, `pi`)
- **Guardrails:** if two panes claim same `task_id`, surface collision warning and require explicit resolve.

### Suggested default keymap (agent-focused)

- `prefix + Space` launcher
- `prefix + b` focus sidebar
- `prefix + B` toggle global sidebar
- `prefix + m/M/u` actionable workflow
- `prefix + a` open “new agent task” prompt prefilled with pane cwd
- `prefix + ?` context-sensitive key help

## Risks and trade-offs

- **Complexity creep:** adding launcher + sidebar + status adapters can overload new users if not progressively disclosed. (tmux discoverability issue context: https://github.com/tmux/tmux/issues/4357)
- **Keybinding conflicts:** terminal/emulator-level shortcuts can clash with tmux maps; requires profile-based defaults and conflict detection. (https://ghostty.org/docs/config/keybind, https://zellij.dev/documentation/keybindings.html)
- **State drift across adapters:** stdout parsing fallback may misclassify status under noisy logs; structured hooks should be default where possible. (https://www.cmux.dev/docs/api)
- **Performance pressure:** large session trees + frequent updates can degrade UX; must throttle redraws and prefer incremental updates.
- **Portability trade-off:** popup-heavy UX is nicer but not equally robust across all terminals; keep pane/sidebar fallback parity. (https://man7.org/linux/man-pages/man1/tmux.1.html)
