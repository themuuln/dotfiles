# Plan: Log Driven Development Protocol Update

## Goal
Update `AGENTS.md` to establish the "Log Driven Development" (LDD) protocol. This ensures efficient debugging for iOS simulators/devices by standardizing how logs are generated, captured, and analyzed by LLMs.

## Context
- **Problem**: Debugging on physical devices/simulators is constrained.
- **Solution**: "Log-First Debugging" where the LLM analyzes raw console output.
- **Key Requirement**: New code must include "Proactive Logging" to make this possible.

## Guidelines (from Analysis)
1.  **Log Structure**: Use `[Category] Message {metadata}` for parseability.
2.  **Guardrails**: 
    -   Wrap debug logs in `#if DEBUG` (or language equivalent) to protect production.
    -   Sanitize PII (Tokens, IDs) before logging.
3.  **Scope**: Applies to *new features* and *debugging sessions*.

## Tasks
- [ ] **Define Log Standards**: Create the "Gold Standard" log format, examples, and tag list (e.g., `[UI]`, `[Net]`).
- [ ] **Draft LDD Section**: Compose the full text for `AGENTS.md`, incorporating:
    -   The LDD Protocol (User sends logs -> Agent analyzes).
    -   The "Proactive Logging" mandate.
    -   The "Gold Standard" format.
    -   Privacy & Safety warnings.
- [ ] **Apply Update**: Append the validated text to `AGENTS.md`.
- [ ] **Verification**: 
    -   Read `AGENTS.md` to confirm formatting.
    -   Verify no existing rules were overwritten.

## Acceptance Criteria
- `AGENTS.md` contains a distinct `# LOG DRIVEN DEVELOPMENT` section.
- The section explicitly mentions `[Category]` format.
- The section explicitly warns about PII and Production builds.
