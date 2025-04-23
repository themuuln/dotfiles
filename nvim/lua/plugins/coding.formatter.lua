return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        dart = { "dart_format", "dartfmt", "lsp_format" },
      },
      -- vim.api.nvim_create_autocmd("BufWritePre", {
      --   pattern = "*",
      --   callback = function(args)
      --     require("conform").format({ bufnr = args.buf })
      --   end,
      -- }),
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("ConformPreSave", { clear = true }),
        callback = function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
      }),
      formatters = {
        dart_format = { command = "dart", args = { "format", "--line-length", "120", "$FILENAME" }, stdin = false },
      },
    },
  },
}
