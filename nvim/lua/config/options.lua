local go = vim.g
local o = vim.opt

o.spell = false

vim.g.ai_cmp = false
vim.g.lazyvim_blink_main = true

-- Define leader key
go.mapleader = " "
go.maplocalleader = "\\"

-- Root dir detection
go.root_spec = {
  "lsp",
  { ".git", "lua", ".obsidian", "package.json", "Makefile", "go.mod", "cargo.toml", "pyproject.toml", "src" },
  "cwd",
}

vim.g.snacks_animate = false
vim.o.scrolloff = 8
vim.o.inccommand = "split"
vim.o.updatetime = 250 -- Performance: reduced frequency of background events
vim.o.timeoutlen = 300

vim.opt.smartindent = true
vim.opt.laststatus = 3
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.signcolumn = "yes"
vim.opt.formatoptions:append({ "r" })
vim.opt.cursorcolumn = false
vim.opt.backup = false
vim.opt.cmdheight = 0
vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup"
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.termguicolors = true
