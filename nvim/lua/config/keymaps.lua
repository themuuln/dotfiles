local lazy = require("lazy")
local wk = require("which-key")
local keymap = vim.keymap
local map = vim.keymap.set
local dap = require("dap")

keymap.set("n", "<C-m>", "<C-i>", { noremap = true, silent = true })
keymap.set("n", "U", ":redo<CR>", { noremap = true, silent = true })
keymap.set("i", "jk", "<Esc>", { noremap = true, silent = false })
keymap.set("n", "<leader>pv", vim.cmd.Ex)
keymap.set("n", "J", "mzJ`z")
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "<C-f>", "<C-f>zz")
keymap.set("n", "<C-b>", "<C-b>zz")
keymap.set("n", "n", "nzz")
keymap.set("n", "N", "Nzz")
keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Continue / Start" })
keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
keymap.set("n", "<S-F11>", dap.step_out, { desc = "Debug: Step Out" })
keymap.set("n", "<C-S-F5>", dap.restart, { desc = "Debug: Restart" })
keymap.set("n", "<S-F5>", function()
  dap.close()
end, { desc = "Debug: Stop" })

-- -- Optional: Visual mode mappings for selecting code to debug (VSCode-like)
-- vim.keymap.set("v", "<F5>", function()
--   dap.continue({ execute_args = vim.fn.getenv("DEBUGPY_ARGS") }) -- Adjust for your lang if needed
-- end, { desc = "Debug: Continue selected" }))
--

-- dial
keymap.set("n", "+", function()
  require("dial.map").manipulate("increment", "normal")
end)
keymap.set("n", "-", function()
  require("dial.map").manipulate("decrement", "normal")
end)
keymap.set("v", "+", function()
  require("dial.map").manipulate("increment", "visual")
end)
keymap.set("v", "-", function()
  require("dial.map").manipulate("decrement", "visual")
end)

-- lazy related
map("n", "<leader>l", "<Nop>")
map("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Lazy" })
map("n", "<leader>ld", function()
  vim.fn.system({ "open", "https://lazyvim.org" })
end, { desc = "LazyVim Docs" })
map("n", "<leader>lr", function()
  vim.fn.system({ "open", "https://github.com/LazyVim/LazyVim" })
end, { desc = "LazyVim Repo" })
map("n", "<leader>lx", "<cmd>LazyExtras<cr>", { desc = "Extras" })
map("n", "<leader>lc", function()
  LazyVim.news.changelog()
end, { desc = "LazyVim Changelog" })
map("n", "<leader>lu", function()
  lazy.update()
end, { desc = "Lazy Update" })
map("n", "<leader>lC", function()
  lazy.check()
end, { desc = "Lazy Check" })
map("n", "<leader>ls", function()
  lazy.sync()
end, { desc = "Lazy Sync" })

wk.add({
  { "<leader>dd", "<cmd>FlutterDebug<cr>", desc = "Debug Flutter App", group = "Debug Flutter App", mode = "n" },
  {
    "<leader>F",
    group = "flutter",
    icon = "󱗆",
    expand = function()
      return require("which-key.extras").expand.buf()
    end,
  },
  { "<leader>Fs", "<cmd>FlutterRun<cr>", desc = "Run Flutter App", mode = "n" },
  {
    "<leader>Fr",
    "<cmd>FlutterRestart<cr>",
    desc = "Restart Flutter App",
    mode = "n",
  },
  {
    "<leader>t",
    group = "toggle",
    expand = function()
      return require("which-key.extras").expand.buf()
    end,
  },
})
