local go = vim.g
local o = vim.opt

-- Optimizations on startup
vim.loader.enable()

vim.g.ai_cmp = false

-- Personal Config and LazyVim global options
go.lualine_info_extras = false
go.lazygit_config = false
go.lazyvim_cmp = "blink"
go.lazyvim_picker = "snacks"

-- Define leader key
go.mapleader = " "
go.maplocalleader = "\\"

-- Autoformat on save (Global)
go.autoformat = true

-- Font
go.gui_font_face = "JetBrainsMono Nerd Font"

-- Root dir detection
go.root_spec = {
  "lsp",
  { ".git", "lua", ".obsidian", "package.json", "Makefile", "go.mod", "cargo.toml", "pyproject.toml", "src" },
  "cwd",
}

-- Disable annoying cmd line stuff
o.showcmd = false
o.laststatus = 3
o.cmdheight = 0

-- Smoothscroll
if vim.fn.has("nvim-0.10") == 1 then
  o.smoothscroll = true
end

vim.g.snacks_animate = true
vim.o.scrolloff = 8
-- useful for renaming across multiple files
vim.o.inccommand = "split"
vim.opt.smartindent = true
vim.opt.laststatus = 3
-- vim.opt.guicursor = ""
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50
-- vim.opt.colorcolumn = "120"
vim.opt.formatoptions:append({ "r" })
vim.g.lazyvim_cmp = "blink.cmp"
vim.opt.cursorcolumn = false

local namespace = vim.api.nvim_create_namespace("dap-hlng")
vim.api.nvim_set_hl(namespace, "DapBreakpoint", { fg = "#eaeaeb", bg = "#ffffff" })
vim.api.nvim_set_hl(namespace, "DapLogPoint", { fg = "#eaeaeb", bg = "#ffffff" })
vim.api.nvim_set_hl(namespace, "DapStopped", { fg = "#eaeaeb", bg = "#ffffff" })
vim.fn.sign_define(
  "DapBreakpoint",
  { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
  "DapBreakpointCondition",
  { text = "ﳁ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
  "DapBreakpointRejected",
  { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
  "DapLogPoint",
  { text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
)
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })
