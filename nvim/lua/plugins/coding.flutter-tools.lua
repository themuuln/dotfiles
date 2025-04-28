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
          evaluate_to_string_in_debug_views = true,
        },
        root_patterns = { ".git", "pubspec.yaml" },
        flutter_path = os.getenv("HOME") .. "/development/flutter/bin/flutter",
        widget_guides = { enabled = true },
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
