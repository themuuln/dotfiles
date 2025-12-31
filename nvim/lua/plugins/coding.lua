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

  -- {
  --   "stevearc/oil.nvim",
  --   ---@module 'oil'
  --   ---@type oil.SetupOpts
  --   opts = {},
  --   dependencies = {
  --     -- { "nvim-mini/mini.icons", opts = {} },
  --     -- {
  --     --   "benomahony/oil-git.nvim",
  --     --   dependencies = { "stevearc/oil.nvim" },
  --     -- },
  --     -- {
  --     --   "JezerM/oil-lsp-diagnostics.nvim",
  --     --   dependencies = { "stevearc/oil.nvim" },
  --     --   opts = {},
  --     -- },
  --     -- {
  --     --   "refractalize/oil-git-status.nvim",
  --     --
  --     --   dependencies = {
  --     --     "stevearc/oil.nvim",
  --     --   },
  --     --
  --     --   config = true,
  --     -- },
  --   },
  --   -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  --   -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  --   lazy = false,
  -- },

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

  { "mg979/vim-visual-multi" },
}
