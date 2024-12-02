return {
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
      "folke/which-key.nvim",
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      local wk = require("which-key")

      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      wk.add({
        { "<leader>d", group = "Debugging", remap = false },
        {
          "<leader>du",
          function()
            dapui.toggle()
          end,
          desc = "Toggle DAP UI",
          remap = false,
        },
        {
          "<leader>dc",
          function()
            dap.continue()
          end,
          desc = "Continue",
          remap = false,
        },
        {
          "<leader>db",
          function()
            dap.toggle_breakpoint()
          end,
          desc = "Toggle Breakpoint",
          remap = false,
        },
        {
          "<leader>dB",
          function()
            dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
          end,
          desc = "Set Conditional Breakpoint",
          remap = false,
        },
        {
          "<leader>dr",
          function()
            dap.repl.open()
          end,
          desc = "Open REPL",
          remap = false,
        },
        {
          "<leader>dl",
          function()
            dap.run_last()
          end,
          desc = "Run Last Session",
          remap = false,
        },
        {
          "<leader>de",
          function()
            dap.terminate()
          end,
          desc = "Terminate Debugging",
          remap = false,
        },
        {
          "<leader>ds",
          function()
            dap.step_over()
          end,
          desc = "Step Over",
          remap = false,
        },
        {
          "<leader>di",
          function()
            dap.step_into()
          end,
          desc = "Step Into",
          remap = false,
        },
        {
          "<leader>do",
          function()
            dap.step_out()
          end,
          desc = "Step Out",
          remap = false,
        },
      })

      vim.keymap.set("n", "<leader>du", function()
        dapui.toggle()
      end, { noremap = true, silent = true, desc = "Toggle DAP UI" })

      vim.keymap.set("n", "<leader>dc", function()
        dap.continue()
      end, { noremap = true, silent = true, desc = "Continue" })

      vim.keymap.set("n", "<leader>db", function()
        dap.toggle_breakpoint()
      end, { noremap = true, silent = true, desc = "Toggle Breakpoint" })

      vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { noremap = true, silent = true, desc = "Set Conditional Breakpoint" })

      vim.keymap.set("n", "<leader>dr", function()
        dap.repl.open()
      end, { noremap = true, silent = true, desc = "Open REPL" })

      vim.keymap.set("n", "<leader>dl", function()
        dap.run_last()
      end, { noremap = true, silent = true, desc = "Run Last Session" })

      vim.keymap.set("n", "<leader>de", function()
        dap.terminate()
      end, { noremap = true, silent = true, desc = "Terminate Debugging" })

      vim.keymap.set("n", "<leader>ds", function()
        dap.step_over()
      end, { noremap = true, silent = true, desc = "Step Over" })

      vim.keymap.set("n", "<leader>di", function()
        dap.step_into()
      end, { noremap = true, silent = true, desc = "Step Into" })

      vim.keymap.set("n", "<leader>do", function()
        dap.step_out()
      end, { noremap = true, silent = true, desc = "Step Out" })
    end,
  },
  {
    "nvim-neotest/nvim-nio",
  },
}
