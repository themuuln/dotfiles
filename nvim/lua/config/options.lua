vim.g.snacks_animate = true
vim.o.scrolloff = 8
vim.opt.cursorcolumn = true
vim.opt.smartindent = true
-- views can only be fully collapsed with the global statusline avante.nvim
vim.opt.laststatus = 3
-- -- vim insert mode cursor style is now `block`
-- vim.opt.guicursor = ""

---------------------------------------------------------------
-- Additional dial.nvim keybinds, conflicts with tmux prefix --
---------------------------------------------------------------

-- Normal Mode Mappings
vim.keymap.set("n", "+", function()
  require("dial.map").manipulate("increment", "normal")
end)
vim.keymap.set("n", "-", function()
  require("dial.map").manipulate("decrement", "normal")
end)

-- Optional: Visual Mode Mappings
vim.keymap.set("v", "+", function()
  require("dial.map").manipulate("increment", "visual")
end)
vim.keymap.set("v", "-", function()
  require("dial.map").manipulate("decrement", "visual")
end)
