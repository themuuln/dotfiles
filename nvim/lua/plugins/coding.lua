return {

  -- {
  --   "chrisgrieser/nvim-scissors",
  --   opts = { jsonFormatter = "jq" },
  --   keys = {
  --     {
  --       "<leader>cB",
  --       function()
  --         require("scissors").editSnippet()
  --       end,
  --       desc = "Edit Snippets",
  --     },
  --     {
  --       "<leader>cb",
  --       mode = { "n", "v" },
  --       function()
  --         require("scissors").addNewSnippet()
  --       end,
  --       desc = "Add Snippets",
  --     },
  --   },
  -- },

  { "mg979/vim-visual-multi" },

  { "nvim-mini/mini.surround", version = false, opts = { n_lines = 100 } },

  {
    "nvim-mini/mini.move",
    opts = {
      mappings = {
        left = "<A-Left>",
        right = "<A-Right>",
        down = "J",
        up = "K",

        line_left = "<A-Left>",
        line_right = "<A-Right>",
        line_down = "<A-Down>",
        line_up = "<A-Up>",
      },
    },
  },
}
