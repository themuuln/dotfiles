## CONVENTIONS

- **State**: `GetxController` + `.obs` variables. Consume with `Obx(() => ...)`.
- **Routing**: Always `Get.toNamed()`. Never `Navigator.push`.
- **DI**: Core controllers in `main.dart`. Access via `Get.find<T>()`.
- **Controller Split**: Large controllers use `part 'file.feature.dart'` + `extension ControllerFeature on Controller`.
- **UI Logic Isolation**: Use `[name].functions.dart` with extension on `_State` class to keep `build()` clean.
- **Feature Controllers**: Can live inside screen folder (e.g., `screens/story/story_controller.dart`).
- **Models**: Manual `fromJson`/`toJson`. All fields `final`. Named params.
- **Function Length**: STRICT 20 lines preferred (max 30). Functions must do ONE thing. Extract widgets/logic ruthlessly.

## LEGENDARY CODE QUALITY (STRICT)

- **Strict Typing**: Explicit types ALWAYS. No `var` (unless obvious), no `dynamic`, no `any`.
- **Immutability**: `final` everywhere. If it changes, it belongs in a `GetxController`.
- **Widget Extraction**: Extract UI to `StatelessWidget` classes with `const` constructors. NEVER use helper methods for widgets.
- **Guard Clauses**: Return early. Avoid `else`. Flatten nested logic.
- **Async Hygiene**: strictly `await` or `unawaited`. No dangling Futures.
- **Const Correctness**: Use `const` literals and constructors aggressively.
- **No Magic Numbers**: Extract ALL constants to `constants/`.
- **Meaningful Names**: Variables name "what" it is. Logic explains "why".
- **No `print()`**: STRICTLY FORBIDDEN. Use `the_log` package. Production apps don't spam stdout.
- **Zombie Code**: Delete commented-out code immediately. Git history exists for a reason.
- **Member Ordering**: `static const` -> `final` fields -> `constructor` -> `lifecycle` -> `public` -> `private`.
- **Theme First**: Never hardcode colors/styles in widgets. Use `AppColors` or `Theme.of(context)`.
- **Import Discipline**: Standard ordering: `dart:` -> `package:` -> `relative`.
- **One Class, One File**: Filenames match class names. Keep files small and focused.

## ANTI-PATTERNS (THIS PROJECT)

- **flutter_bloc**: In pubspec but **FORBIDDEN**. Use GetX only.
- **Navigator.pop(context)**: Use `Get.back()` in controllers.
- **Logic in build()**: Move to controller or `[name].functions.dart` extension.
- **Direct API calls from UI**: Route through `lib/api/` classes.
- **BuildContext in controllers**: Use `Get.context`, `Get.dialog()`, `Get.bottomSheet()`.
- **json_serializable**: Not used. All models are hand-written.

## MCP TOOLING & CAPABILITIES

This workspace is equipped with **Dart & Flutter MCP** tools. Use these preferentially over raw shell commands for better context and safety.

### 1. Initialization (REQUIRED)

- **Start**: Always initialize the session by registering the project root.
  - Tool: `dart-mcp-server_add_roots(roots=[{uri: "file:///absolute/path/to/project"}])`

### 2. Development Loop

- **Run App**: Use `dart-mcp-server_launch_app` to run on simulators/devices.
  - _Benefit_: Returns a process ID (PID) for controlling the app.
- **Hot Reload**: Use `dart-mcp-server_hot_reload` after **EVERY** code change to apply updates immediately.
- **Logs**: Use `dart-mcp-server_get_app_logs` to stream structured logs.
- **Restart**: Use `dart-mcp-server_hot_restart` to reset state.

### 3. Debugging & Inspection

- **Widget Tree**: `dart-mcp-server_get_widget_tree` to see the actual UI hierarchy.
- **Runtime Errors**: `dart-mcp-server_get_runtime_errors` for active exceptions.
- **Symbol Lookup**: `dart-mcp-server_resolve_workspace_symbol` to find definitions quickly.

### 4. Code Maintenance

- **Analysis**: `dart-mcp-server_analyze_files` (Superior to `flutter analyze`).
- **Auto-Fix**: `dart-mcp-server_dart_fix` to automatically apply linter fixes.
- **Deps**: `dart-mcp-server_pub` for adding/removing packages.

## COMMANDS

```bash
# Run
flutter run

# Code gen (Envied only)
dart run build_runner build --delete-conflicting-outputs

# Analyze (Legacy - prefer MCP analyze_files)
flutter analyze

```

# WORKFLOW PROTOCOL: ISOLATION REQUIRED

Whenever I give you a new coding task, you must NEVER modify the current working directory directly if it is the main branch or root of the repo.

**Step 1: Check Context**

- Check if we are currently inside a specific git worktree for this task.
- If not, you must create one immediately.

**Step 2: Create Worktree (Enhanced)**

- Generate a branch name from the task description (e.g., `feat/add-login`).
- Run: `./scripts/worktree_manager.sh create <branch-name>`
- **Features Active:**
  - **Shadow Storage:** Worktree is created in `~/.opencode_worktrees/` to keep root clean.
  - **Instant Start:** `node_modules` are symlinked and `.env` files copied automatically.
  - **tmux Sync:** If in tmux, a new window `OC:<branch>` is spawned.
- **CRITICAL:** You must `cd` into the path reported by the script before making edits.

**Step 3: Execution**

- Only then, proceed with the task.

# PROTOCOL: TASK COMPLETION & MERGE

**Trigger Keywords:**
When I say "finished", "done", "test completed", or "merge this", you must initiate the Merge Sequence.

**Step 1: Verification**

- **Run Tests:** Execute the project's test suite.
- **Run Static Analysis:** If this is a Flutter project, you MUST run `flutter analyze` (or MCP equivalent) and ensure it returns zero issues.
- **If Tests or Analysis Fail:** STOP. Do not merge. Fix the errors first.
- **If All Pass:** Proceed to Step 2.

**Step 2: Commit & Snapshot**

- Ensure the working tree is clean: `git add .`
- Run: `./scripts/worktree_manager.sh cleanup <branch-name>`
- **Note:** This takes a "Snapshot" commit of your current state and pushes it to origin before removing the worktree.

**Step 3: The Merge Dance (CRITICAL)**

1. **Switch Context:** Go back to the main repo root.
2. **Merge:**
   - `git checkout main` (or `dev`).
   - `git pull origin main`.
   - `git merge --no-ff <branch-name>`.
3. **Cleanup:**
   - `git branch -d <branch-name>` (Local branch deletion).

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

- Reproduce the reported issue on the physical device.
- Capture the full log stream (e.g., via Xcode Console, ADB, or file export).
- Paste the raw logs into the chat for analysis.

## Agent Role

- **Proactive Logging:** Always add logging to new features _during implementation_, not just after bugs are found.
- **Pattern Matching:** Analyze timestamps and sequences to detect race conditions.
- **Sanitization Check:** Verify that suggested logging code does not expose secrets.

## Log Standards

Adhere strictly to this structured format to ensure parseability:

**Format:**
`[Category] Message {metadata}`

- **Category:** The subsystem or feature area (e.g., `[Auth]`, `[BLE]`, `[Nav]`).
- **Message:** A clear, human-readable description of the event.
- **Metadata:** A key-value set (JSON-style) containing variable state, IDs, or error codes.

## Safety

- **Conditional Compilation:** Wrap debug logs in `#if DEBUG` (Swift) or `if (BuildConfig.DEBUG)` (Kotlin) to protect production performance and binary size.
- **Data Privacy:** **NEVER** log PII (emails, names), Auth Tokens, or Passwords.
- **Sanitization:** Always mask sensitive IDs (e.g., `userId: ***52a`) before logging.

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
