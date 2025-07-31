return {
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = {
  --     -- inlay_hints = { enabled = false },
  --   },
  -- },
  -- {
  --   "neovim/nvim-lspconfig",
  -- },

  {
    "neovim/nvim-lspconfig",

    dependencies = { "saghen/blink.cmp" },
    opts = {
      inlay_hints = { enabled = false },
      diagnostics = { virtual_text = { prefix = "icons" } },
      capabilities = {
        workspace = {
          didChangeWatchedFiles = {
            dynamicRegistration = false,
          },
        },
      },
    },
  },
  {
    "stevearc/dressing.nvim",
    opts = {},
  },
  -- {
  --   "yarospace/dev-tools.nvim",
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter", -- code manipulation in buffer, required
  --     {
  --       "folke/snacks.nvim", -- optional
  --       opts = {
  --         picker = { enabled = true }, -- actions picker
  --         terminal = { enabled = true }, -- terminal for running spec actions
  --       },
  --     },
  --     {
  --       "ThePrimeagen/refactoring.nvim", -- refactoring library, optional
  --       dependencies = { "nvim-lua/plenary.nvim" },
  --     },
  --   },
  --
  --   opts = {
  --     ---@type Action[]|fun():Action[]
  --     actions = {},
  --
  --     filetypes = { -- filetypes for which to attach the LSP
  --       include = {}, -- {} to include all, except for special buftypes, e.g. nofile|help|terminal|prompt
  --       exclude = {},
  --     },
  --   },
  -- },
}
