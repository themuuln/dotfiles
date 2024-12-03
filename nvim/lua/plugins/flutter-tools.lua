return {
  {
    "akinsho/flutter-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("flutter-tools").setup({
        lsp = {
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
        },
        flutter = {
          dev_tools = {
            enabled = true,
            open_cmd = "tabnew",
          },
          widget_guides = {
            enabled = true,
          },
        },
        ui = {
          notification = true,
          start_on_open = true,
        },
        formatter = {
          enabled = true,
          format_on_save = true,
        },
      })
    end,
  },
}
