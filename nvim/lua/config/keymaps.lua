local lazy = require("lazy")
local wk = require("which-key")
vim.g.flutter_is_running = false
local keymap = vim.keymap
local map = vim.keymap.set

keymap.set("n", "<C-m>", "<C-i>", { noremap = true, silent = true })
keymap.set("n", "U", ":redo<CR>", { noremap = true, silent = true })
keymap.set("i", "jk", "<Esc>", { noremap = true, silent = false })
vim.keymap.set({ "n", "x" }, "<leader>ca", function()
  require("tiny-code-action").code_action()
end, { noremap = true, silent = true })
keymap.set("n", "<leader>pv", vim.cmd.Ex)
keymap.set("n", "J", "mzJ`z")
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "n", "nzz")
keymap.set("n", "N", "Nzz")

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
vim.keymap.set("n", "<leader>tt", function()
  local cat = require("catppuccin")
  cat.options.transparent_background = not cat.options.transparent_background
  cat.compile()
  vim.cmd.colorscheme(vim.g.colors_name)
end)

-- F5 mapping
map("n", "<F5>", function()
  vim.cmd("FlutterDebug")
end, { desc = "Debug Flutter App" })

-- Ctrl+Shift+F5 → FlutterHotRestart
map("n", "<C-S-F5>", function()
  vim.cmd("FlutterRestart")
end, { desc = "Hot Restart Flutter App" })

-- Shift+F5 → FlutterQuit
map("n", "<S-F5>", function()
  vim.cmd("FlutterQuit")
end, { desc = "Stop Flutter App" })

-- F9 → Toggle breakpoint (DAP)
map("n", "<F9>", function()
  local ok, dap = pcall(require, "dap")
  if ok then
    dap.toggle_breakpoint()
  else
    vim.notify("nvim-dap not found", vim.log.levels.WARN)
  end
end, { desc = "Toggle Breakpoint" })

vim.keymap.set("n", "gf", function()
  local path = vim.fn.expand("<cfile>")
  local file, line, col = path:match("([^:]+):(%d+):(%d+)")
  if file and line and col then
    vim.cmd("edit " .. file)
    vim.fn.cursor(tonumber(line) or 1, tonumber(col) or 1)
    return
  end
  file, line = path:match("([^:]+):(%d+)")
  if file and line then
    vim.cmd("edit " .. file)
    vim.fn.cursor(tonumber(line) or 1, 1)
    return
  end
  vim.cmd("edit " .. path)
end, { desc = "gf with support for file:line:col" })
