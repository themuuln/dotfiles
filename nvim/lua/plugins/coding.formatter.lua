return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    exclude_filetypes = { "dart" },
    formatters_by_ft = {
      ["javascript"] = { "dprint", "prettier" },
      ["javascriptreact"] = { "dprint" },
      ["typescript"] = { "dprint", "prettier" },
      ["typescriptreact"] = { "dprint" },
    },
    formatters = {
      dprint = {
        condition = function(_, ctx)
          return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
        end,
      },
    },
  },
}
