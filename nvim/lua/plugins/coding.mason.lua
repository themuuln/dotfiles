return {
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
