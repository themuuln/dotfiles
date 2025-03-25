return {
  -- for http requests postman, insomnia alternative
  {
    "mistweaverco/kulala.nvim",
    keys = {
      {
        "<leader>Ra",
        "<cmd>lua require('kulala').set_selected_env()<cr>",
        desc = "Set selected request as current",
        ft = "http",
      },
    },
    opts = { default_env = "test" },
  },
  -- -- Typr for warm-up
  -- {
  --   "nvzone/typr",
  --   dependencies = "nvzone/volt",
  --   opts = {},
  --   cmd = { "Typr", "TyprStats" },
  -- },
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
