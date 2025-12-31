return {
  -- dartls interrupt solution
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        dartls = {},
      },
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
      { "<leader>dr", "<cmd>FlutterLogToggle<cr>", desc = "Toggle Log" },
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
        dev_log = {
          enabled = true,
          notify_errors = true,
        },
        default_run_args = { flutter = "--pid-file=.flutter.pid" },
        dev_tools = { autostart = false, auto_open_browser = false },
        lsp = {
          settings = {
            showTodos = false,
            completeFunctionCalls = false,
            enableSdkFormatter = true,
            analysisExcludedFolders = {
              os.getenv("HOME") .. "/development/flutter/packages",
              os.getenv("HOME") .. "/.pub-cache",
              vim.fn.getcwd() .. "/build",
              vim.fn.getcwd() .. "/.dart_tool",
              vim.fn.getcwd() .. "/.git",
            },
          },
        },
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = { exclude_filetypes = { "dart" } },
  },
}
