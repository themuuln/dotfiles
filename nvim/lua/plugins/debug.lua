return {
  { "dart-lang/dart-vim-plugin" },
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    ft = "dart",
    config = function()
      require("flutter-tools").setup({
        debugger = {
          enabled = true,
          run_via_dap = true,
          register_configurations = function(_)
            local dap = require("dap")
            dap.adapters.dart = {
              type = "executable",
              command = "/Users/ict/development/flutter/bin/flutter",
              args = { "debug_adapter" },
            }
            dap.configurations.dart = {
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
        decorations = {
          statusline = {
            app_version = true,
            device = true,
          },
        },

        flutter_path = "/Users/ict/development/flutter/bin/flutter",
        widget_guides = {
          enabled = true,
        },
        closing_tags = {
          highlight = "Comment",
          prefix = "//",
        },
        lsp = {
          color = {
            enabled = true,
            background = true,
            virtual_text = true,
          },
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            renameFilesWithClasses = "prompt",
            enableSnippets = true,
            updateImportsOnRename = true,
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
        {
          type = "dart",
          request = "launch",
          name = "Launch Flutter",
          program = "${workspaceFolder}/lib/main.dart",
          cwd = "${workspaceFolder}",
          flutterSdkPath = "/Users/ict/development/flutter/bin",
          dartSdkPath = "/Users/ict/development/flutter/bin/cache/dart-sdk/bin/dart",
          toolArgs = { "--hot-reload" },
          args = {},
        },
        {
          type = "dart",
          request = "attach",
          name = "Attach Flutter",
          dartSdkPath = "/Users/ict/development/flutter/bin/cache/dart-sdk/bin/dart",
          flutterSdkPath = "/Users/ict/development/flutter/bin",
          program = "${workspaceFolder}/lib/main.dart",
          cwd = "${workspaceFolder}",
          toolArgs = { "--hot-reload" },
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
