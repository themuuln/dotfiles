- Use 'bd' for task tracking

# WORKFLOW PROTOCOL: ISOLATION REQUIRED

Whenever I give you a new coding task, you must NEVER modify the current working directory directly if it is the main branch or root of the repo.

**Step 1: Check Context**

- Check if we are currently inside a specific git worktree for this task.
- If not, you must create one immediately.

**Step 2: Create Worktree**

- Generate a branch name from the task description (e.g., `feat/add-login`).
- Run: `git worktree add ../<branch-name> <branch-name>`
- **CRITICAL:** You must `cd` into that new directory before making edits.
- If you cannot `cd` (because you are in a fixed shell session), strictly instruct me to `cd` there before you proceed.

**Step 3: Execution**

- Only then, proceed with the task.

# PROTOCOL: TASK COMPLETION & MERGE

**Trigger Keywords:**
When I say "finished", "done", "test completed", or "merge this", you must initiate the Merge Sequence.

**Step 1: Verification**

- **Run Tests:** Execute the project's test suite (e.g., `npm test`, `pytest`, or `cargo test`).
- **Run Static Analysis:** If this is a Flutter project, you MUST run `flutter analyze` and ensure it returns zero issues.
- **If Tests or Analysis Fail:** STOP. Do not merge. Fix the errors first.
- **If All Pass:** Proceed to Step 2.

**Step 2: Commit & Push**

- Ensure the working tree is clean: `git add . && git commit -m "Complete task: <summary>"`
- Push the branch to origin (backup): `git push origin <current-branch-name>`

**Step 3: The Merge Dance (CRITICAL)**
_Since we are in a worktree, we cannot checkout 'main' here. We must go to the root._

1. **Identify paths:** Note the current directory name (e.g., `feature-login-wt`) and the branch name.
2. **Switch Context:** `cd ..` (Go back to the main repo root).
3. **Merge:**
   - `git checkout main` (or `dev` depending on user preference, show selectable options to user).
   - `git pull origin main` (Ensure main is up to date).
   - `git merge --no-ff <branch-name>` (Merge the agent's work).
4. **Cleanup:**
   - `git worktree remove <worktree-folder-name>`
   - `git branch -d <branch-name>`

**Step 4: Report**

- "Task completed, merged to main, and worktree cleaned up. Ready for next task."

# Log Driven Development (LDD)

## Protocol
The LDD workflow standardizes debugging on mobile devices (iOS/Android) where direct debugger attachment is difficult or impossible. It relies on high-fidelity structured logging to reconstruct state and control flow.

1.  **Instrumentation:** Agent proactively injects structured logging into code paths.
2.  **Reproduction:** User performs the workflow on the device.
3.  **Extraction:** User provides raw console output or log files.
4.  **Analysis:** Agent parses logs to pinpoint failure modes, timing issues, or state corruption.

## User Role
-   Reproduce the reported issue on the physical device.
-   Capture the full log stream (e.g., via Xcode Console, ADB, or file export).
-   Paste the raw logs into the chat for analysis.

## Agent Role
-   **Proactive Logging:** Always add logging to new features *during implementation*, not just after bugs are found.
-   **Pattern Matching:** Analyze timestamps and sequences to detect race conditions.
-   **Sanitization Check:** Verify that suggested logging code does not expose secrets.

## Log Standards
Adhere strictly to this structured format to ensure parseability:

**Format:**
`[Category] Message {metadata}`

-   **Category:** The subsystem or feature area (e.g., `[Auth]`, `[BLE]`, `[Nav]`).
-   **Message:** A clear, human-readable description of the event.
-   **Metadata:** A key-value set (JSON-style) containing variable state, IDs, or error codes.

## Safety
-   **Conditional Compilation:** Wrap debug logs in `#if DEBUG` (Swift) or `if (BuildConfig.DEBUG)` (Kotlin) to protect production performance and binary size.
-   **Data Privacy:** **NEVER** log PII (emails, names), Auth Tokens, or Passwords.
-   **Sanitization:** Always mask sensitive IDs (e.g., `userId: ***52a`) before logging.

## Gold Standard Example
```text
[Network] User profile fetch failed {status=401, endpoint="/api/v1/me", duration_ms=150, error="Token expired"}
```

# AGENT CHANGELOG PROTOCOL

**Objective:**
Maintain a granular history of agent-performed tasks for auditability and tracking.

**1. Location & Structure**
- Root directory: `./changelogs/`
- Date-based subdirectories: `./changelogs/YYYY-MM-DD/`
- File naming: `<HHMM>-<kebab-case-task-name>.md`
  - Example: `changelogs/2026-01-26/1430-refactor-auth-middleware.md`

**2. Content Template**
Each changelog file must contain:
- **Task**: The original user request or ticket.
- **Changes**: Bullet points of key modifications.
- **Files**: List of touched files.
- **Verification**: How the changes were verified (tests, manual checks).

**3. Execution Timing**
- Create this log entry **before** initiating the "Task Completion & Merge" sequence.
