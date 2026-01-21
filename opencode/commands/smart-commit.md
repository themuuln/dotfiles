---
description: Orchestrated commit using subtasks
agent: build
model: google/antigravity-gemini-3-flash
---

# Step 1: Call the Architect Subtask

!/analyze-groups

# Step 2: Execute based on Architect's output

Based on the JSON groups provided above:

1. Unstage all files (`git reset`).
2. For each group:
   - `git add <files>`
   - Generate a commit message (English header, Mongolian body).
   - Execute `git commit`.
