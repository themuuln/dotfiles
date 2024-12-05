local keymap = vim.keymap

keymap.set("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })
-- Map 'jk' to escape in insert mode
vim.api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = true, silent = true })
