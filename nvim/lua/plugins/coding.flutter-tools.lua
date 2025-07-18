return {
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
          evaluate_to_string_in_debug_views = true,
        },
        flutter_path = os.getenv("HOME") .. "/development/flutter/bin/flutter",
        widget_guides = { enabled = false },
        dev_log = { enabled = false },
        dev_tools = { autostart = false, auto_open_browser = false },
        lsp = {
          color = {
            enabled = false,
            foreground = false,
            virtual_text = true,
            virtual_text_str = "■",
          },
          settings = {
            lineLength = 120,
            showTodos = false,
            -- already provided by blink.nvim
            completeFunctionCalls = false,
            enableSnippets = true,
            updateImportsOnRename = true,
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
}
