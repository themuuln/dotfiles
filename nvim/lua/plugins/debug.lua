return {
  { "stevearc/dressing.nvim" },
  {
    "nvim-flutter/flutter-tools.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    ft = "dart",
    config = function()
      require("flutter-tools").setup({
        flutter_path = nil,
        fvm = false,
        widget_guides = { enabled = true },
        dev_log = {
          enabled = true,
          open_cmd = "tabnew",
        },
        lsp = {
          settings = {
            lineLength = 120,
            showtodos = true,
            completefunctioncalls = true,
            analysisexcludedfolders = {
              vim.fn.expand("$Home/.pub-cache"),
            },
            renamefileswithclasses = "prompt",
            updateimportsonrename = true,
            enablesnippets = true,
          },
        },
      })
    end,
  },
  -- {
  --   "akinsho/flutter-tools.nvim",
  --   event = "VeryLazy",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "stevearc/dressing.nvim",
  --   },
  --   config = function()
  --     require("flutter-tools").setup({
  --       flutter_path = "/Users/ict/development/flutter/bin/flutter",
  --       -- flutter_lookup_cmd = "asdf where flutter",
  --       widget_guides = { enabled = true },
  --       lsp = {
  --         settings = {
  --           lineLength = 100,
  --           showtodos = true,
  --           completefunctioncalls = true,
  --           analysisexcludedfolders = {
  --             vim.fn.expand("$Home/.pub-cache"),
  --           },
  --           renamefileswithclasses = "prompt",
  --           updateimportsonrename = true,
  --           enablesnippets = false,
  --         },
  --       },
  --       debugger = {
  --         enabled = true,
  --         run_via_dap = true,
  --         exception_breakpoints = {},
  --         register_configurations = function()
  --           local dap = require("dap")
  --           dap.adapters.dart = {
  --             type = "executable",
  --             command = "/Users/ict/development/flutter/bin/flutter",
  --             args = { "debug-adapter" },
  --             options = {
  --               detached = false,
  --             },
  --           }
  --           dap.configurations.dart = {
  --             {
  --               type = "dart",
  --               request = "launch",
  --               name = "Launch Dart Program",
  --               program = "${workspaceFolder}/lib/main.dart",
  --               cwd = "${workspaceFolder}",
  --             },
  --           }
  --           require("dap.ext.vscode").load_launchjs()
  --         end,
  --       },
  --     })
  --   end,
  -- },
  {
    "dart-lang/dart-vim-plugin",
    ft = "dart",
    config = function()
      vim.g.dart_enable_hover = 1
      vim.g.dart_sdk_path = "/Users/ict/development/flutter/bin/cache/dart-sdk"
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
    },
    event = "VeryLazy",
    config = function()
      require("dapui").setup({
        icons = { expanded = "▾", collapsed = "▸" },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              "breakpoints",
              "stacks",
              "watches",
            },
            size = 10, -- columns
            position = "bottom",
          },
        },
      })
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
