return {
  require("treesitter-context").setup({
    multiwindow = true,
    trim_scope = "outer",
    mode = "topline",
  }),
  { "neovim/nvim-lspconfig", opts = { inlay_hints = { enabled = false } } },
}
