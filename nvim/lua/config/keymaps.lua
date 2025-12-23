vim.keymap.set("n", "<C-m>", "<C-i>", { noremap = true, silent = true })
vim.keymap.set("n", "U", ":redo<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "J", "mzJ`z")

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
  vim.keymap.set("n", "<leader>,", "<Cmd>call VSCodeNotify('workbench.action.showAllEditors')<CR>")
  vim.keymap.set("n", "<leader><Cr>", "<Cmd>call VSCodeNotify('oil-code.open')<CR>")
  vim.keymap.set("n", "<leader>tn", "<Cmd>call VSCodeNotify('workbench.action.createTerminalEditor')<CR>")
  vim.keymap.set("n", "<leader>/", "<Cmd>call VSCodeNotify('workbench.action.quickTextSearch')<CR>")
  vim.keymap.set("n", "<leader>gg", "<Cmd>call VSCodeNotify('lazygit.openLazygit')<CR>")
  vim.keymap.set("n", "gd", "<Cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>")
  vim.keymap.set("n", "gr", "<Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>")
  vim.keymap.set("n", "[h", "<Cmd>call VSCodeNotify('workbench.action.editor.previousChange')<CR>")
  vim.keymap.set("n", "]h", "<Cmd>call VSCodeNotify('workbench.action.editor.nextChange')<CR>")
end
