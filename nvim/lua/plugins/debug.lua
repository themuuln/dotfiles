return {
  { "dart-lang/dart-vim-plugin" },
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    opts = {
      decorations = {
        statusline = {
          device = true,
          project_config = true,
        },
      },
      flutter_path = "/Users/ict/development/flutter/bin/flutter",
      widget_guides = {
        enabled = false,
      },
      dev_tools = {
        autostart = true,
        auto_open_browser = true,
      },
      -- outline = {
      --   open_cmd = "20vnew", -- command to use to open the outline buffer
      --   auto_open = true, -- if true this will open the outline automatically when it is first populated
      -- },
      lsp = {
        color = {
          enabled = true,
          background = true, -- highlight the background
          foreground = true, -- highlight the foreground
          virtual_text = true,
          virtual_text_str = "■", -- the virtual text character to highlight
        },
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
          enableSnippets = true,
          updateImportsOnRename = true,
        },
      },
    },
    config = true,
  },
}
