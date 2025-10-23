local go = vim.g
local o = vim.opt

o.spell = false

vim.loader.enable()
vim.g.ai_cmp = false
go.lazyvim_cmp = "blink"

-- Define leader key
go.mapleader = " "
go.maplocalleader = "\\"

go.autoformat = true

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

-- -- Smoothscroll
-- if vim.fn.has("nvim-0.10") == 1 then
--   o.smoothscroll = true
-- end

vim.g.snacks_animate = false
vim.o.scrolloff = 8
vim.o.inccommand = "split"
vim.opt.smartindent = true
vim.opt.laststatus = 3
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
-- vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- set directory where undo files are stored
-- vim.opt.signcolumn = "yes"
-- vim.opt.updatetime = 50
-- vim.opt.colorcolumn = "120"
vim.opt.formatoptions:append({ "r" })
vim.opt.cursorcolumn = false

vim.opt.backup = true
vim.opt.cmdheight = 0
vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup"

vim.g.deprecation_warnings = true
vim.env.FZF_DEFAULT_OPTS = ""
vim.g.ai_cmp = false
o.termguicolors = true
