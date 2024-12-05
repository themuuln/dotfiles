return {
  {
    "nvim-flutter/flutter-tools.nvim",
    opts = {
      lsp = {
        settings = {
          -- Adjust this based on your preferred line length
          lineLength = 120,
        },
      },
      debugger = {
        enabled = true, -- Enable debugger support
        run_via_dap = true, -- Use nvim-dap for debugging
      },
      widget_guides = {
        enabled = true, -- Adds widget indentation guides
      },
      outline = {
        auto_open = true, -- Automatically open the Flutter Outline
      },
      dev_log = {
        enabled = true, -- Enable logging
        open_cmd = "tabnew", -- Open logs in a new tab
      },
    },
    lazy = false, -- Load eagerly to avoid lazy-loading issues
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for async support
      "stevearc/dressing.nvim", -- Optional UI enhancements
      "mfussenegger/nvim-dap", -- Dependency for debugging
    },
    config = true,
    keys = {
      -- Flutter commands with handy key mappings
      { "<leader>dr", "<cmd>FlutterRun<CR>", desc = "Flutter Run" },
      { "<leader>dd", "<cmd>FlutterDevices<CR>", desc = "Flutter Devices" },
      { "<leader>de", "<cmd>FlutterEmulators<CR>", desc = "Flutter Emulators" },
      { "<leader>dl", "<cmd>FlutterReload<CR>", desc = "Flutter Reload" },
      { "<leader>dR", "<cmd>FlutterRestart<CR>", desc = "Flutter Restart" },
      { "<leader>dq", "<cmd>FlutterQuit<CR>", desc = "Flutter Quit" },
      { "<leader>do", "<cmd>FlutterOutlineToggle<CR>", desc = "Flutter Outline Toggle" },
      { "<leader>dc", "<cmd>FlutterLogClear<CR>", desc = "Flutter Log Clear" },
      { "<leader>dt", "<cmd>FlutterLogToggle<CR>", desc = "Flutter Log Toggle" },
    },
  },
  {
    "dart-lang/dart-vim-plugin",
    ft = "dart", -- Load this plugin for Dart files only
    config = function()
      vim.g.dart_enable_hover = 1 -- Enable hover support
      vim.g.dart_sdk_path = "/Users/ict/development/flutter/bin/cache/dart-sdk" -- Set Dart SDK path
    end,
  },
}
