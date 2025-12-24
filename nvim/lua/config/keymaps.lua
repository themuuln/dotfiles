vim.keymap.set("n", "<C-m>", "<C-i>", { desc = "Jump to older position in jump list" })
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Netrw file explorer" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines keeping cursor position" })

-- center on navigation
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-f>", "<C-f>zz")
vim.keymap.set("n", "<C-b>", "<C-b>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- dial
vim.keymap.set("n", "+", function()
  require("dial.map").manipulate("increment", "normal")
end)
vim.keymap.set("n", "-", function()
  require("dial.map").manipulate("decrement", "normal")
end)
vim.keymap.set("v", "+", function()
  require("dial.map").manipulate("increment", "visual")
end)
vim.keymap.set("v", "-", function()
  require("dial.map").manipulate("decrement", "visual")
end)

vim.keymap.set(
  "v",
  "<S-j>",
  ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv",
  { desc = "Move Down", silent = true }
)
vim.keymap.set(
  "v",
  "<S-k>",
  ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv",
  { desc = "Move Up", silent = true }
)

if vim.g.vscode then
  vim.keymap.set("n", "<leader>,", "<Cmd>call VSCodeNotify('workbench.action.showAllEditors')<CR>", { desc = "Show all editors" })
  vim.keymap.set("n", "<leader><Cr>", "<Cmd>call VSCodeNotify('oil-code.open')<CR>", { desc = "Open oil" })
  vim.keymap.set("n", "<leader>tn", "<Cmd>call VSCodeNotify('workbench.action.createTerminalEditor')<CR>", { desc = "Create terminal" })
  vim.keymap.set("n", "<leader>/", "<Cmd>call VSCodeNotify('workbench.action.quickTextSearch')<CR>", { desc = "Quick text search" })
  vim.keymap.set("n", "<leader>gg", "<Cmd>call VSCodeNotify('lazygit.openLazygit')<CR>", { desc = "Open lazygit" })
  vim.keymap.set("n", "gd", "<Cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>", { desc = "Go to definition" })
  vim.keymap.set("n", "gr", "<Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>", { desc = "Go to references" })
  vim.keymap.set("n", "[h", "<Cmd>call VSCodeNotify('workbench.action.editor.previousChange')<CR>", { desc = "Previous change" })
  vim.keymap.set("n", "]h", "<Cmd>call VSCodeNotify('workbench.action.editor.nextChange')<CR>", { desc = "Next change" })
end
