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
}
