return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      setup = {
        dartls = function()
          return true
        end,
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
        "<S-F11>",
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
      {
        "<leader>FS",
        function()
          require("config.flutter_remote").run()
        end,
        desc = "Run Flutter App on iMac",
      },
      {
        "<leader>FW",
        function()
          require("config.flutter_remote").watch()
        end,
        desc = "Watch Flutter Sync on iMac",
      },
      {
        "<leader>Fq",
        function()
          require("config.flutter_remote").stop()
        end,
        desc = "Stop Remote Flutter",
      },
      { "<leader>Fs", "<cmd>FlutterRun<cr>", desc = "Run Flutter App" },
      {
        "<leader>Fr",
        function()
          local remote = require("config.flutter_remote")
          if remote.is_running() then
            remote.restart()
          else
            vim.cmd("FlutterRestart")
          end
        end,
        desc = "Restart Flutter App",
      },
      {
        "<leader>r",
        function()
          local remote = require("config.flutter_remote")
          if remote.is_running() then
            remote.reload()
          else
            vim.cmd("FlutterReload")
          end
        end,
        desc = "Reload Flutter App",
      },
    },
    ft = { "dart" },
    config = function()
      require("flutter-tools").setup({
        debugger = {
          enabled = true,
          run_via_dap = true,
          exception_breakpoints = {},
        },
        flutter_path = os.getenv("HOME") .. "/development/flutter/bin/flutter",
        dev_log = {
          enabled = false,
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
      require("config.flutter_remote").setup()
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        dart = {},
      },
    },
  },
}
