return {
  require("treesitter-context").setup({
    multiwindow = true,
    trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    mode = "topline", -- Line used to calculate context. Choices: 'cursor', 'topline'
  }),
  { "neovim/nvim-lspconfig", opts = { inlay_hints = { enabled = false } } },
}
