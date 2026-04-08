# tmux Validation Dry Run — 2026-04-08

## Commands executed + outcomes

1. Baseline resources/toolchain
   - `sysctl -n vm.loadavg`, `sysctl -n hw.logicalcpu`, `sysctl -n hw.memsize`, `ps -A | wc -l`, `vm_stat | head -n 6`
   - `command -v` + version probes for `tmux`, `bash`, `fzf`, `opencode`, `codex`, `droid`, `pi`
   - Outcome: all required tools found and version-resolved.

2. Isolated tmux dry run (`-L missiondryrun`)
   - `tmux -L missiondryrun -f /Users/ict/.config/tmux/tmux.conf new-session -d -s missiondryrun -n main`
   - `tmux -L missiondryrun source-file /Users/ict/.config/tmux/tmux.conf`
   - `tmux -L missiondryrun new-window -d ...`, `split-window -d ...`
   - `tmux -L missiondryrun bind-key -n F12 display-popup -E "echo popup_parse_ok"` + `list-keys` verification + `unbind-key`
   - Outcome: config loaded without immediate error; representative window/split/pop-up command parsing passed.

3. Plugin loadability/syntax checks
   - `bash -n` over local custom plugin scripts under:
     - `/Users/ict/.config/tmux/plugins/tmux-window-name-lite/**/*.sh`
     - `/Users/ict/.config/tmux/plugins/tmux-workspace-sidebar/**/*.sh`
   - Outcome: `28` shell scripts checked, `0` syntax failures.
   - `tmux source-file` on plugin entry `.tmux` files returned `invalid environment variable` (see blockers), then validated correctly via:
   - `tmux -L missiondryrun run-shell /Users/ict/.config/tmux/plugins/tmux-window-name-lite/window-name-lite.tmux`
   - `tmux -L missiondryrun run-shell /Users/ict/.config/tmux/plugins/tmux-workspace-sidebar/sidebar.tmux`
   - Outcome: both plugin entry scripts executed successfully under `run-shell`.

4. Post-run + cleanup
   - Re-captured resource stats with same baseline commands.
   - `tmux -L missiondryrun kill-server` and re-check with `list-sessions`.
   - Outcome: isolated dry-run server cleaned up successfully.

## Blockers/gaps

- `source-file` is not the correct loader for these plugin entry files (`window-name-lite.tmux`, `sidebar.tmux`) because they are Bash scripts (`#!/usr/bin/env bash`); direct `source-file` fails with:
  - `invalid environment variable` at line 3.
- `display-popup` was validated through CLI parse/bind checks in an isolated detached server, not visually rendered through an attached interactive client.

## Resource profile (before/after)

| Metric | Before | After |
|---|---:|---:|
| Timestamp (UTC) | 2026-04-08T03:06:41Z | 2026-04-08T03:08:49Z |
| Load average | `{ 7.42 8.22 7.91 }` | `{ 13.79 10.88 9.02 }` |
| Logical CPU | 8 | 8 |
| Physical memory | 17179869184 bytes (16 GiB) | 17179869184 bytes (16 GiB) |
| Process count | 690 | 709 |

Mission-specific footprint snapshot while active:
- Isolated tmux server process observed: RSS ~`3104 KB`
- Mission pane shell (`zsh`) observed: RSS ~`3472 KB`
- Combined observed mission footprint: ~`6.6 MB` + very low CPU activity.

## Recommended validation surface/tools

- Use isolated tmux socket for all validator runs:
  - `tmux -L <socket> -f /Users/ict/.config/tmux/tmux.conf ...`
- Core readiness checks:
  1. `source-file` on main tmux config.
  2. CLI checks for `new-window`, `split-window`, and `display-popup` parse via `bind-key`/`list-keys`.
  3. `bash -n` on local custom plugin shell scripts.
  4. Plugin entrypoint validation via `run-shell` (not `source-file`) for Bash-backed `.tmux` scripts.
- Required tools confirmed present: `tmux`, `bash`, `fzf`, `opencode`, `codex`, `droid`, `pi`.

## Recommended max concurrent validators (1-5) with rationale

**Recommendation: 5 (max in requested scale).**

Rationale (70% headroom, conservative rounding):
- Per-validator mission footprint observed is small (~2 lightweight processes, ~6.6 MB RSS, low CPU).
- With 16 GiB RAM, reserving 70% headroom leaves ~4.8 GiB budget; even pessimistic per-validator rounding (~10 MB) stays far below budget at 5 concurrent runs.
- CPU impact from mission processes remained low during dry run; at scale limit 5, projected tmux-validator CPU remains well within a 30% utilization budget on an 8-logical-CPU host.
