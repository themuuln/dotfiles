return {
  -- dartls interrupt solution
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- fix conflict with other dart lsp servers
        dartls = {},
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = { virtual_text = { prefix = "icons" } },
      inlay_hints = { enabled = false },
    },
  },

  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "Debug: Continue / Start",
      },
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "Debug: Step Over",
      },
      {
        "<F11>",
        function()
          require("dap").step_into()
        end,
        desc = "Debug: Step Into",
      },
      {
        "<S-F11",
        function()
          require("dap").step_out()
        end,
        desc = "Debug: Step Out",
      },
      {
        "<C-S-F5>",
        function()
          require("dap").restart()
        end,
        desc = "Debug: Restart",
      },
      {
        "<S-F5>",
        function()
          require("dap").close()
        end,
        desc = "Debug: Stop",
      },
    },
  },

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
        debugger = {
          enabled = true,
          run_via_dap = true,
          exception_breakpoints = {},
          -- evaluate_to_string_in_debug_views = false,
        },
        flutter_path = os.getenv("HOME") .. "/development/flutter/bin/flutter",
        default_run_args = { flutter = "--pid-file=.flutter.pid" }, -- Default options for run command (i.e `{ flutter = "--no-version-check" }`). Configured separately for `dart run` and `flutter run`.
        widget_guides = { enabled = true },
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

  {
    "stevearc/conform.nvim",
    opts = {
      exclude_filetypes = {
        "dart",
      },
    },
  },
}
