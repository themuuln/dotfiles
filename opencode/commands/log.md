---
description: Inject logs using the custom AppLogger (logDebug, logError, logger.pretty)
---

Analyze the selected code or cursor position and inject logging using the project's custom `AppLogger` utility.

# Import Rule

Ensure the logger file is imported.
`import 'package:your_app_name/path/to/logger_util.dart';` (Adjust path as found in context).

# Logic Modes

## Mode A: Complex Objects (Map, List, Models)

If the user selects or highlights a variable that looks like a Map, List, or Class:

- **Action**: Use `logger.pretty()`.
- **Output**:
  ```dart
  logger.pretty(myVariable);
  ```

## Mode B: Simple Variables (String, Int, Bool)

If the user selects a simple value:

- **Action**: Use `logDebug()`.
- **Output**:
  ```dart
  logDebug("Value of myVar: $myVar");
  ```

## Mode C: Function Tracing (No selection)

If the cursor is inside a function:

- **Action**: Log the entry.
- **Output**:
  ```dart
  logTrace("Entering function: functionName");
  ```

## Mode D: Error Handling ("Wrap in try-catch")

If the user asks to handle errors:

- **Action**: Wrap code in try-catch and use `logError` with stack trace.
- **Output**:
  ```dart
  try {
    // original code
  } catch (e, s) {
    logError("Operation failed", error: e, stackTrace: s);
  }
  ```

# User Input

{{user_input}}
