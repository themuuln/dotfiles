return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = { virtual_text = { prefix = "icons" } },
      -- capabilities = {
      --   workspace = {
      --     didChangeWatchedFiles = {
      --       dynamicRegistration = false,
      --     },
      --   },
      -- },
      inlay_hints = { enabled = false },
    },
  },

  { "stevearc/dressing.nvim", lazy = true, ft = { "dart" } },

  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = true,
    keys = {
      { "<leader>dd", "<cmd>FlutterDebug<cr>", desc = "Debug Flutter App" },
      { "<leader>FC", "<cmd>FlutterDebug<cr>", desc = "Debug Flutter App" },
      { "<leader>Fs", "<cmd>FlutterRun<cr>", desc = "Run Flutter App" },
      { "<leader>Fr", "<cmd>FlutterRestart<cr>", desc = "Restart Flutter App" },
    },
    ft = { "dart" },
    config = function()
      require("flutter-tools").setup({
        decorations = {
          statusline = {
            -- set to true to be able use the 'flutter_tools_decorations.app_version' in your statusline
            -- this will show the current version of the flutter app from the pubspec.yaml file
            app_version = true,
            -- set to true to be able use the 'flutter_tools_decorations.device' in your statusline
            -- this will show the currently running device if an application was started with a specific
            -- device
            device = true,
            -- set to true to be able use the 'flutter_tools_decorations.project_config' in your statusline
            -- this will show the currently selected project configuration
            project_config = true,
          },
        },
        debugger = {
          enabled = true,
          run_via_dap = true,
          -- exception_breakpoints = {},
          -- evaluate_to_string_in_debug_views = false,
        },
        flutter_path = os.getenv("HOME") .. "/development/flutter/bin/flutter",
        default_run_args = nil, -- Default options for run command (i.e `{ flutter = "--no-version-check" }`). Configured separately for `dart run` and `flutter run`.
        -- widget_guides = { enabled = true },
        dev_log = { enabled = false },
        dev_tools = { autostart = false, auto_open_browser = false },
        lsp = {
          settings = {
            lineLength = 120,
            showTodos = false,
            completeFunctionCalls = false,
            enableSdkFormatter = true,
            analysisExcludedFolders = {
              os.getenv("HOME") .. "/development/flutter/packages",
              vim.fn.expand("$Home/.pub-cache"),
            },
          },
        },
      })
    end,
  },

  { "stevearc/conform.nvim", opts = { exclude_filetypes = { "dart" } } },
}
