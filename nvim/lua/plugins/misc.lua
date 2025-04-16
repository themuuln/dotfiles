return {
  { "andweeb/presence.nvim" },
  {
    "zhisme/copy_with_context.nvim",
    config = function()
      require("copy_with_context").setup({
        mappings = {
          relative = "<leader>cy",
          absolute = "<leader>cY",
        },
        trim_lines = true,
        context_format = "# %s:%s", -- Default format for context: "# Source file: filepath:line"
      })
    end,
  },
}
