return {
  { "dart-lang/dart-vim-plugin" },
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    ft = { "dart" },
    config = function()
      require("flutter-tools").setup({
        debugger = {
          enabled = true,
          run_via_dap = true,
          exception_breakpoints = "default",
          evaluate_to_string_in_debug_views = true,
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
                flutterSdkPath = "/Users/ict/development/flutter/bin/flutter",
                program = "${workspaceFolder}/lib/main.dart",
                cwd = "${workspaceFolder}",
                args = { "development" },
              },
            }
          end,
        },
        flutter_path = "/Users/ict/development/flutter/bin/flutter",
        widget_guides = { enabled = true },
        closing_tags = { highlight = "Comment", prefix = "// " }, -- Added space after //
        dev_log = {
          enabled = false,
          open_cmd = "botright 15new",
          auto_open = false,
        },
        lsp = {
          color = { enabled = true, background = true, virtual_text = true },
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            enableSnippets = true,
            updateImportsOnRename = true,
            renameFilesWithClasses = "prompt", -- Add this
            enableSdkFormatter = true, -- Add this
          },
          on_attach = function(client, bufnr)
            -- Add any custom on_attach logic here
          end,
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
        {
          type = "dart",
          request = "launch",
          name = "Launch Flutter",
          program = "${workspaceFolder}/lib/main.dart",
          cwd = "${workspaceFolder}",
          flutterSdkPath = "/Users/ict/development/flutter/bin",
          dartSdkPath = "/Users/ict/development/flutter/bin/cache/dart-sdk/bin/dart",
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
