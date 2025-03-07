return {
  -- Dart format with 120 as line-length
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = { dart = { "dart_format" } },
      formatters = {
        dart_format = { command = "dart", args = { "format", "--line-length", "120", "$FILENAME" }, stdin = false },
      },
    },
  },
}
