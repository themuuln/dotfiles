local wk = require("which-key")

vim.keymap.set("n", "<C-m>", "<C-i>", { noremap = true, silent = true })
vim.keymap.set("n", "U", ":redo<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = false })
vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = false })

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
  {
    "<leader>Fy",
    "<cmd>FlutterLogToggle<cr>",
    desc = "Flutter Log Toggle",
    group = "Flutter Log Toggle",
    mode = "n",
  },
  {
    "<leader>FY",
    "<cmd>FlutterLogToggle<cr>",
    desc = "Flutter Log Toggle",
    group = "Flutter Log Toggle",
    mode = "n",
  },
})
