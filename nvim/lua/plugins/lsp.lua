return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    opts = {
      inlay_hints = { enabled = false },
    },
  },

  { "stevearc/dressing.nvim", lazy = true, ft = { "dart" } },

  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    ft = { "dart" },
    config = function()
      require("flutter-tools").setup({
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
            renameFilesWithClasses = "prompt",
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
