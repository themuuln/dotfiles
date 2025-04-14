vim.g.snacks_animate = true
vim.o.scrolloff = 8
vim.opt.cursorcolumn = true
vim.opt.smartindent = true
-- views can only be fully collapsed with the global statusline avante.nvim
vim.opt.laststatus = 3
-- -- vim insert mode cursor style is now `block`
-- vim.opt.guicursor = ""
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
