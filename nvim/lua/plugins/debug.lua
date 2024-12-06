return {
  { "stevearc/dressing.nvim" },
  {
    "nvim-flutter/flutter-tools.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("flutter-tools").setup({
        flutter_path = nil,
        lsp = { settings = { lineLength = 120 } },
        fvm = false,
        widget_guides = { enabled = true },
        -- lsp = {
        --   settings = {
        --     showtodos = true,
        --     completefunctioncalls = true,
        --     analysisexcludedfolders = {
        --       vim.fn.expand("$Home/.pub-cache"),
        --     },
        --     renamefileswithclasses = "prompt",
        --     updateimportsonrename = true,
        --     enablesnippets = false,
        --   },
        -- },
      })
      -- require("dap.ext.vscode").load_launchjs()
    end,
  },
  {
    "dart-lang/dart-vim-plugin",
    ft = "dart",
    config = function()
      vim.g.dart_enable_hover = 1
      vim.g.dart_sdk_path = "/Users/ict/development/flutter/bin/cache/dart-sdk"
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = { "nvim-neotest/nvim-nio", "rcarriga/nvim-dap-ui" },
    event = "VeryLazy",
  },
  {
    "williamboman/mason-nvim-dap.nvim",
    requires = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    config = function()
      require("mason-nvim-dap").setup()
    end,
  },
}
