return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "lua",
        "regex",
        "vim",
        "yaml",
        "json",
        "dart",
        "http",
        "markdown",
        "markdown_inline",
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "dart-debug-adapter",
        "json-lsp",
        "lua-language-server",
        "stylua",
      },
    },
  },
}
