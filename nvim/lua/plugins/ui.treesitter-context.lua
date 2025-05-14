return {
  require("treesitter-context").setup({
    multiwindow = true,
    trim_scope = "outer",
    mode = "topline",
  }),
}
