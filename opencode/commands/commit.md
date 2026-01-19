---
description: Generate standard git commit message (English header, Mongolian body)
agent: build
---

Analyze the staged changes (or recent edits) and generate a `git commit` command that adheres to the Company Standard.

# Company Standard Guidelines

1.  **Structure**:

    ```text
    type(scope): subject in english

    Detailed description in Mongolian.
    ```

2.  **Scope is MANDATORY**:
    - Every commit must have a scope in parentheses.
    - Format: `lower_snake_case` (e.g., `auth_service`, `login_ui`).
3.  **Languages**:
    - **Subject**: English (Imperative mood, no period at end).
    - **Body**: Mongolian (Concise but detailed enough to explain the "why").
4.  **Allowed Types**:
    - `feat`: New feature (minor version).
    - `fix`: Bug fix (patch version).
    - `docs`: Documentation updates.
    - `chore`: Routine maintenance, config, CI/CD.
    - `ref`: Refactoring (no logic change).
    - `feat!`: Breaking change (major version).

# Output Format

Return ONLY the bash command to execute. Do not provide markdown explanation.

Example Output:

```bash
git commit -m "feat(user_profile): add avatar upload functionality" -m "Хэрэглэгчийн профайл зураг хуулах функцийг нэмж, AWS S3 тохиргоог хийв."
```
