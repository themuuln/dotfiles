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
- **If Tests Fail:** STOP. Do not merge. Fix the errors first.
- **If Tests Pass:** Proceed to Step 2.

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
