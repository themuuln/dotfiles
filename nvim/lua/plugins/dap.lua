return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "williamboman/mason.nvim",
  },
  config = function()
    local dap = require("dap")

    dap.adapters.dart = {
      type = "executable",
      command = "/Users/ict/development/flutter/bin/flutter",
      args = { "debug-adapter" },
    }

    dap.configurations.dart = {
      {
        type = "dart",
        request = "launch",
        name = "Launch Flutter",
        program = "${workspaceFolder}/lib/main.dart",
        cwd = "${workspaceFolder}",
        dartSdkPath = "/Users/ict/development/flutter/bin/cache/dart-sdk/",
        flutterSdkPath = "/Users/ict/development/flutter/bin/flutter",
      },
    }

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
  end,
}
