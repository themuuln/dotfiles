---
name: tmux-plugin-worker
description: Implement tmux workspace-agent plugin features (key tables, workspace actions, agent CLI integration, and hybrid status compatibility) with isolated-socket verification.
---

# tmux-plugin-worker

NOTE: Startup and cleanup are handled by `worker-base`. This skill defines the WORK PROCEDURE.

## When to Use This Skill

Use for features that modify:
- `tmux/plugins/tmux-workspace-agent/**`
- `tmux/tmux.conf` integration wiring for workspace-agent
- compatibility logic with `tmux-workspace-sidebar` / `tmux-window-name-lite`

## Required Skills

- `tuistory` — required when a feature includes interactive key-flow verification (launcher behavior, confirm/cancel paths, dead-end checks).

## Work Procedure

1. Read mission context first:
   - mission feature spec
   - `/Users/ict/.factory/missions/<mission-id>/AGENTS.md`
   - `.factory/library/architecture.md`
   - `.factory/library/user-testing.md`
2. Run init + baseline checks from `.factory/services.yaml`.
3. Implement tests first (red):
   - Add/extend shell-based checks under plugin test scripts or deterministic command assertions.
   - Execute the targeted checks and confirm failure before implementation.
4. Implement feature behavior (green):
   - Update plugin entrypoint and scripts with minimal, scoped changes.
   - Keep key behavior namespaced under `@workspace_agent_*` and `workspace_agent` key table.
5. Re-run targeted checks until green.
6. Run interactive verification for relevant assertions:
   - Use isolated tmux socket.
   - Invoke `tuistory` for interactive evidence where assertion requires key-driven behavior.
7. Run validators from `.factory/services.yaml` (`lint`, `test`; plus `typecheck` if defined).
8. Ensure no orphaned tmux test servers remain.
9. Prepare handoff with explicit evidence, including commands, exits, and observed outcomes.

## Example Handoff

```json
{
  "salientSummary": "Implemented Prefix+g workspace_agent key table with launcher and quick relaunch wiring, plus idempotent reload guards. Added workspace create/switch/rename handlers and validated isolated-socket behavior.",
  "whatWasImplemented": "Added tmux-workspace-agent plugin scaffold, namespaced options, key bindings, and shell handlers for launcher operations. Implemented safe create/switch/rename branches with feedback and no-op protection. Updated tmux.conf wiring and ensured compatibility with existing local plugin setup under isolated tmux sockets.",
  "whatWasLeftUndone": "",
  "verification": {
    "commandsRun": [
      {
        "command": "bash -n /Users/ict/.config/tmux/plugins/tmux-workspace-agent/workspace-agent.tmux",
        "exitCode": 0,
        "observation": "Entrypoint syntax valid"
      },
      {
        "command": "tmux -L feat_ws -f /Users/ict/.config/tmux/tmux.conf new-session -d -s feat_ws && tmux -L feat_ws source-file /Users/ict/.config/tmux/tmux.conf && tmux -L feat_ws list-keys -T workspace_agent",
        "exitCode": 0,
        "observation": "workspace_agent table contains a/A/q bindings"
      },
      {
        "command": "tmux -L feat_ws kill-server",
        "exitCode": 0,
        "observation": "Isolated test server cleaned up"
      }
    ],
    "interactiveChecks": [
      {
        "action": "Prefix+g then a, open launcher, cancel, then Prefix+g then A",
        "observed": "No dead-end; context preserved; quick relaunch route reachable"
      }
    ]
  },
  "tests": {
    "added": [
      {
        "file": "tmux/plugins/tmux-workspace-agent/tests/workspace_actions.sh",
        "cases": [
          {
            "name": "create rejects duplicate and blank names",
            "verifies": "No session created on invalid input paths"
          },
          {
            "name": "switch handles current/missing targets safely",
            "verifies": "No context drift on no-op/error paths"
          }
        ]
      }
    ]
  },
  "discoveredIssues": []
}
```

## When to Return to Orchestrator

- Required CLI (`opencode`, `codex`, `droid`, `pi`) behavior cannot be validated due to missing binaries/environment constraints.
- Existing plugin conflicts require architectural decision (hook ownership or option contract conflict not resolvable by additive chaining).
- tmux behavior differs from expected contract in a way that would require changing validation assertions.
