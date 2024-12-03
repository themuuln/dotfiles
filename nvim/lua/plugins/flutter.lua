return {
  {
    "nvim-flutter/flutter-tools.nvim",
    opts = {
      lsp = { settings = { lineLength = 120 } },
    },
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- optional for vim.ui.select
    },
    config = true,
    keys = {
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
    ft = "dart",
    config = function()
      vim.g.dart_enable_hover = 1
      vim.g.dart_sdk_path = "/Users/ict/development/flutter/bin/cache/dart-sdk"
    end,
  },
}
