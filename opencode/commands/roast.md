---
description: Critical performance and security audit (Senior Level)
agent: explore
---

Act as a Principal Engineer doing a strict code review.
Analyze the selected code specifically for:

1.  **Performance Killers**:
    - Unnecessary `build()` method triggers.
    - Heavy computations on the Main Thread (suggest Isolate).
    - Lack of `const` constructors.
    - ListViews inside Columns without Expanded/ShrinkWrap (Layout thrashing).

2.  **Memory Leaks**:
    - Unclosed Streams, Controllers, or Listeners.
    - BuildContext used across async gaps.

3.  **Security**:
    - Hardcoded secrets.
    - Insecure storage usage.

# Output Format

- **Bullet points** of critical issues found.
- **Code snippet** showing ONLY the fixed version of the specific problematic lines.
- Be concise and direct. If code is perfect, say "LGTM".
