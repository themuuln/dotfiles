-- Map 'jk' to escape in insert mode
vim.api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = true, silent = true })
-- Jumplist
vim.keymap.set("n", "<C-m>", "<C-i>", { noremap = true, silent = true })

vim.keymap.set("n", "te", "tabedit", { noremap = true, silent = true })
vim.keymap.set("n", "<tab>", ":tabnext<Return>", { noremap = true, silent = true })
vim.keymap.set("n", "<s-tab>", ":tabprev<Return>", { noremap = true, silent = true })
vim.keymap.set("n", "U", ":redo<CR>", { noremap = true, silent = true })
-- Flutter Log Toggle
-- vim.keymap.set("n", "<C-S-y>", ":FlutterLogToggle<CR>", { noremap = true, silent = true })
