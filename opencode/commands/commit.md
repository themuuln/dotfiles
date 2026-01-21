---
description: Analyze changes, group by logic, and directly execute separate commits (English header, Mongolian body)
model: google/antigravity-gemini-3-flash
---

Analyze the current changes (staged or working directory). **Identify if there are multiple distinct logical groups** (different scopes, unrelated features, etc.).

# Execution Workflow

1.  **Multi-Group Detection**:
    - If the changes belong to different logical scopes (e.g., a fix in `auth` vs. a new feature in `ui`), you **MUST** split them.
    - **Action**: Run `git reset` to unstage everything first.
    - **Loop**: For each distinct logical group:
      1.  `git add <specific_files>`
      2.  Execute `git commit` (see standards below).

2.  **Single Group**:
    - If all changes belong to one logical task, ensure they are staged and execute a single commit.

# Company Standard Guidelines

1.  **Structure**:

    ```text
    type(scope): subject in english

    Detailed description in Mongolian.
    ```

2.  **Scope is MANDATORY**:
    - Format: `lower_snake_case` (e.g., `auth_service`, `login_ui`).
3.  **Languages**:
    - **Subject**: English (Imperative mood, no period).
    - **Body**: Mongolian (Concise, explaining the "why").
4.  **Allowed Types**: `feat`, `fix`, `docs`, `chore`, `ref`, `feat!`.

# Execution Instructions

- **DO NOT** ask for confirmation.
- **DO NOT** output the command as text.
- **DIRECTLY RUN** the necessary `git add` and `git commit` commands in the terminal.
