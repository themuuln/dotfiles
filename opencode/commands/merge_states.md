---
description: Merge selected Figma frames into a single interactive Flutter widget with states.
---

I have selected multiple frames in Figma. These represent different **states** of a single interactive component (e.g., Collapsed, Hover, Expanded, Loading).

**Your Task:**

1.  Analyze all selected nodes from Figma.
2.  Identify the "Base" state (usually the smallest or first one) and the "Active/Expanded" state.
3.  Create a **SINGLE** Flutter `StatefulWidget`.
4.  Implement the logic to switch between these designs using a boolean flag (e.g., `bool isExpanded`).
5.  Use Flutter animations (`AnimatedContainer`, `AnimatedOpacity`, or `ExpansionTile`) to transition smoothly between the visual states found in the Figma selection.

**Important:** Do not output separate widgets for each frame. Output one widget that changes its appearance based on state.
