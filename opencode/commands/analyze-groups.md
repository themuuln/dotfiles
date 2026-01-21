---
description: Analyze staged files and group them by logical scope
model: google/antigravity-gemini-3-flash
---

Analyze the `git diff --staged` and `git status`.
Return a JSON list of logical groups.
Example output:
[
{"scope": "auth", "files": ["src/auth.ts"]},
{"scope": "ui", "files": ["src/components/Button.tsx"]}
]
