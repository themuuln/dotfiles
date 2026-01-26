# Flutter Environment Selector for Neovim

## Context

### Original Request
User wants to select an environment (Production, Development) when running Flutter from Neovim.
The selection should inject `--dart-define=ENVIRONMENT=...` into the `flutter run` command.
The UI should use `folke/snacks.nvim` picker style.

### Interview Summary
**Key Discussions**:
- **Interface**: User requested a Command (`:FlutterRun`) rather than a keybinding.
- **UI**: Floating terminal for output (default Snacks behavior).
- **Tech Stack**: Neovim (Lua), Snacks.nvim.

**Research Findings**:
- Current directory is `.config/nvim`.
- `lua/plugins/snacks.lua` exists, confirming Snacks usage.
- LazyVim structure allows adding new files to `lua/plugins/` for auto-loading.

---

## Work Objectives

### Core Objective
Implement a `:FlutterRun` command in Neovim that prompts for environment selection and runs the configured Flutter command in a floating terminal.

### Concrete Deliverables
- [x] New file: `lua/plugins/flutter.lua`

### Definition of Done
- [ ] `:FlutterRun` command exists in Neovim.
- [ ] Running it shows a selection menu (Production, Development, Staging).
- [ ] Selecting an option opens a terminal running `flutter run --dart-define=ENVIRONMENT=<selection>`.

### Must Have
- Use `Snacks.terminal` for output.
- Use `vim.ui.select` (integrated with Snacks) for selection.
- Handle lowercasing of environment names.

---

## Verification Strategy

### Manual Verification
This is a Neovim configuration change. Verification requires interacting with Neovim.

**Procedure**:
1.  **Restart Neovim** to load the new plugin file.
2.  **Run Command**: Type `:FlutterRun`.
    - *Expected*: A picker window appears with options: "Production", "Development", "Staging".
3.  **Select Option**: Choose "Development".
    - *Expected*: A floating terminal opens.
    - *Expected Command* (visible in terminal title or output): `flutter run --dart-define=ENVIRONMENT=development` (or just running).
4.  **Verify Output**: Since we are not in a Flutter project, `flutter run` might fail with "No pubspec.yaml found".
    - *Success*: If the command *attempts* to run (even if it fails due to directory), the integration works.

---

## TODOs

- [x] 1. Create `lua/plugins/flutter.lua`

  **What to do**:
  - Define a new Lazy.nvim plugin spec.
  - Hook into `folke/snacks.nvim`.
  - In `init`, create the user command `FlutterRun`.
  - Implement the `vim.ui.select` logic.

  **Code Structure**:
  ```lua
  return {
    {
      "folke/snacks.nvim",
      init = function()
        vim.api.nvim_create_user_command("FlutterRun", function()
          local envs = { "Production", "Development", "Staging" }
          vim.ui.select(envs, {
            prompt = "Select Flutter Environment",
            format_item = function(item) return "Run " .. item end,
          }, function(choice)
            if choice then
              local cmd = "flutter run --dart-define=ENVIRONMENT=" .. choice:lower()
              Snacks.terminal(cmd, {
                win = { style = "float", position = "float" },
                interactive = true
              })
            end
          end)
        end, { desc = "Run Flutter with Environment Selection" })
      end,
    },
  }
  ```

  **Parallelizable**: NO

  **References**:
  - `lua/plugins/snacks.lua` - Reference for existing Snacks setup.
  - `lua/config/keymaps.lua` - Where other user commands/maps might live (for context).

  **Acceptance Criteria**:
  - [ ] File created at `lua/plugins/flutter.lua`.
  - [ ] Content matches the Lua code structure above.

---

## Success Criteria

### Final Checklist
- [ ] `:FlutterRun` is available in command mode.
- [ ] Selection menu works.
- [ ] Command constructs correctly with `--dart-define`.
