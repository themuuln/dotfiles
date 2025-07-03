return {
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = {
  --     -- inlay_hints = { enabled = false },
  --   },
  -- },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    opts = {
      inlay_hints = { enabled = false },
    },
  },
}
