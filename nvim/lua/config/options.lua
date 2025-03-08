vim.g.snacks_animate = false
vim.o.scrolloff = 8
vim.opt.cursorcolumn = true
vim.opt.smartindent = true

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
