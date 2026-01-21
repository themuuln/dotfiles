---
name: figma-flutter
description: Expert capability to convert Figma selections into production-ready Flutter widgets using MCP.
---

# Figma to Flutter Conversion Guidelines

You are an expert Flutter engineer. When retrieving design data from the Figma MCP (via `get_design_context` or `get_nodes`), follow these strict rules to generate Dart code.

## 1. Layout Mapping

- **Auto Layout (Vertical):** Use `Column`.
- **Auto Layout (Horizontal):** Use `Row`.
- **Absolute Position:** Use `Stack` with `Positioned` widgets.
- **Padding:** Wrap the child in `Padding` (e.g., `Padding(padding: EdgeInsets.all(16), child: ...)`).
- **Spacing/Gap:** Use `SizedBox(height: X)` or `SizedBox(width: X)` between children.

## 2. Styling & Decor

- **Fills/Backgrounds:** Use `Container` with `decoration: BoxDecoration(...)`.
- **Corner Radius:** Use `borderRadius: BorderRadius.circular(X)`.
- **Shadows:** Use `BoxShadow` inside the `BoxDecoration`.
- **Colors:** If a variable is provided (e.g., `primary/500`), use a constant or theme reference (e.g., `AppColors.primary500` or `Theme.of(context).primaryColor`). Do NOT hardcode hex values if a variable name is available.

## 3. Typography

- **Text:** Use `Text` widget.
- **Styles:** Map font weight, size, and line height to `TextStyle`.
- **Null Safety:** Ensure all named parameters and nullable types strictly adhere to Dart Sound Null Safety.

## 4. Code Structure

- **StatelessWidget:** Default to creating a `class MyComponent extends StatelessWidget`.
- **Const Correctness:** Apply the `const` keyword wherever possible.
- **Imports:** Include `import 'package:flutter/material.dart';` at the top.

## 5. Handling Unknowns

- If a Figma node is an instance of a component (e.g., "Primary Button"), ask the user if they want to map it to an existing widget in the codebase or build it from scratch.

## 6. Handling Multiple States (Variants)

If the user selects multiple frames and indicates they are states of the same component (e.g., "Collapsed", "Expanded"):

1.  **Analyze Differences:** Compare the frames to see what changed (height, visibility of child elements, rotation of icons).
2.  **Use StatefulWidget:** Generate a `StatefulWidget`.
3.  **State Variables:** Create boolean variables for the states (e.g., `bool _isExpanded = false;`).
4.  **Animation:** If the height changes, use `AnimatedContainer` or `ExpansionPanel`. If elements appear/disappear, use `AnimatedCrossFade` or `Visibility`.
5.  **Interactivity:** Add `GestureDetector` or `InkWell` on the trigger area (header) to toggle the boolean state.
