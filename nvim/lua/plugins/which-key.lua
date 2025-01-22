return {
  "folke/which-key.nvim",
  opts = {
    defaults = {
      -- Add a new keybinding under the <leader>d group
      ["<leader>d"] = { name = "+debug" }, -- Ensure the `d` group has a name for clarity
      ["<leader>dy"] = { ":FlutterLogToggle<CR>", "Toggle Flutter Logs" }, -- Keybinding to run the command
    },
  },
}
