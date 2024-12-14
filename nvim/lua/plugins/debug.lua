return {
  {
    "nvim-flutter/flutter-tools.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    ft = "dart",
    config = function()
      require("flutter-tools").setup({
        flutter_path = nil,
        fvm = false,
        widget_guides = { enabled = true },
        log = { enabled = true, open_cmd = "tabedit" },
        dev_log = { enabled = true, open_cmd = "tabedit" },
        debugger = { enabled = true, run_via_dap = true },
        lsp = {
          settings = {
            lineLength = 120,
            showtodos = true,
            completefunctioncalls = true,
            analysisexcludedfolders = { vim.fn.expand("$Home/.pub-cache") },
            renamefileswithclasses = "prompt",
            updateimportsonrename = true,
            enablesnippets = true,
          },
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = { "nvim-neotest/nvim-nio", "rcarriga/nvim-dap-ui" },
    event = "VeryLazy",
    config = function()
      local dap = require("dap")
      dap.adapters.dart = {
        type = "executable",
        command = "/Users/ict/development/flutter/bin/flutter",
        args = { "debug_adapter" },
      }
      dap.configurations.dart = {
        -- Remove Comoments for Dart Development
        -- {
        --   type = "dart",
        --   request = "launch",
        --   name = "Launch Dart",
        --   dartSdkPath = "/Users/ict/development/flutter/bin/cache/dart-sdk/bin/dart",
        --   flutterSdkPath = "/Users/ict/development/flutter/bin",
        --   program = "${workspaceFolder}/lib/main.dart",
        --   cwd = "${workspaceFolder}",
        -- },
        {
          type = "dart",
          request = "launch",
          name = "Launch Flutter",
          dartSdkPath = "/Users/ict/development/flutter/bin/cache/dart-sdk/bin/dart",
          flutterSdkPath = "/Users/ict/development/flutter/bin",
          program = "${workspaceFolder}/lib/main.dart",
          cwd = "${workspaceFolder}",
        },
      }
    end,
  },
  {
    "williamboman/mason-nvim-dap.nvim",
    requires = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    config = function()
      require("mason-nvim-dap").setup()
    end,
  },
}
