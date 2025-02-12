local wk = require("which-key")

vim.keymap.set("n", "<C-m>", "<C-i>", { noremap = true, silent = true })
vim.keymap.set("n", "U", ":redo<CR>", { noremap = true, silent = true })

wk.add({
  { "<leader>dd", "<cmd>FlutterDebug<cr>", desc = "Debug Flutter App", group = "Debug Flutter App", mode = "n" },

  {
    "<leader>F",
    group = "flutter",
    expand = function()
      return require("which-key.extras").expand.buf()
    end,
  },
  { "<leader>Fs", "<cmd>FlutterRun<cr>", desc = "Run Flutter App", group = "Run Flutter App", mode = "n" },
  { "<leader>Fr", "<cmd>FlutterRestart<cr>", desc = "Restart Flutter App", group = "Restart Flutter App", mode = "n" },
})
