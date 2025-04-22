return {
  require("treesitter-context").setup({
    multiwindow = true,
    trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    mode = "topline", -- Line used to calculate context. Choices: 'cursor', 'topline'
  }),

  -- turn off inlay hint by default
  -- { "neovim/nvim-lspconfig", opts = { inlay_hints = { enabled = false } } },
  { "nvim-lspconfig", opts = { inlay_hints = { enabled = true } } },
}
