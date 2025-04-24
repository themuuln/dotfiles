return {
  { "nvim-lua/plenary.nvim" },
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = true,
    ft = { "dart" },
    config = function()
      require("flutter-tools").setup({
        debugger = {
          enabled = true,
          run_via_dap = true,
          exception_breakpoints = "default",
          -- evaluate_to_string_in_debug_views = true,
          evaluate_to_string_in_debug_views = false,
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
              {
                type = "dart",
                request = "attach",
                name = "Attach to Flutter",
                dartSdkPath = "/Users/ict/development/flutter/bin/cache/dart-sdk/bin/dart",
                flutterSdkPath = "/Users/ict/development/flutter/bin/flutter",
                program = "${workspaceFolder}/lib/main.dart",
                cwd = "${workspaceFolder}",
                args = { "development" },
              },
            }
          end,
        },
        root_patterns = { ".git", "pubspec.yaml" },
        flutter_path = "/Users/ict/development/flutter/bin/flutter",
        widget_guides = { enabled = false },
        closing_tags = { highlight = "Comment", prefix = "// " },
        dev_log = { enabled = false },
        dev_tools = { autostart = false, auto_open_browser = false },
        lsp = {
          color = {
            enabled = true,
            foreground = true,
            virtual_text = true,
            virtual_text_str = "■",
          },
          settings = {
            lineLength = 120,
            showTodos = false,
            completeFunctionCalls = true,
            enableSnippets = true,
            updateImportsOnRename = true,
            renameFilesWithClasses = "prompt",
            enableSdkFormatter = true,
            analysisExcludedFolders = { os.getenv("HOME") .. "/development/flutter/packages" },
          },
        },
      })
    end,
  },
}
