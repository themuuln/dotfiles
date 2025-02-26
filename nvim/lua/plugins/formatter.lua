return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = { dart = { "dart_format" } },
      formatters = {
        dart_format = { command = "dart", args = { "format", "--line-length", "120", "$FILENAME" }, stdin = false },
      },
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
    },
  },
}
