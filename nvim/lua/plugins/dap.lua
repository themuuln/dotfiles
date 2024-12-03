return {
  { import = "lazyvim.plugins.extras.dap.core" },
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "williamboman/mason.nvim",
    "akinsho/flutter-tools.nvim",
  },
  config = function()
    vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "", linehl = "", numhl = "" })

    local dap = require("dap")
    local flutter_path = "/Users/ict/development/flutter/bin/flutter"
    local dart_sdk_path = flutter_path .. "/cache/dart-sdk/"

    dap.adapters.dart = {
      type = "executable",
      command = flutter_path,
      args = { "debug-adapter" },
    }

    -- DAP UI setup
    require("dapui").setup()
    vim.keymap.set("n", "<leader>du", function()
      require("dapui").toggle()
    end, { noremap = true, silent = true, desc = "Toggle DAP UI" })

    -- Key bindings for debugging
    vim.keymap.set("n", "<F5>", function()
      require("dap").continue()
    end, { noremap = true, silent = true })
    vim.keymap.set("n", "<F10>", function()
      require("dap").step_over()
    end, { noremap = true, silent = true })
    vim.keymap.set("n", "<F11>", function()
      require("dap").step_into()
    end, { noremap = true, silent = true })
    vim.keymap.set("n", "<F12>", function()
      require("dap").step_out()
    end, { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>b", function()
      require("dap").toggle_breakpoint()
    end, { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>B", function()
      require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { noremap = true, silent = true })
    vim.keymap.set("n", "<F6>", function()
      require("dap").restart()
    end, { noremap = true, silent = true, desc = "Restart Debugger" })
  end,
}
