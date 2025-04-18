local wk = require("which-key")

vim.keymap.set("n", "<C-m>", "<C-i>", { noremap = true, silent = true })
vim.keymap.set("n", "U", ":redo<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = false })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "J", "mzJ`z")
-- vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

wk.add({
  { "<leader>dd", "<cmd>FlutterDebug<cr>", desc = "Debug Flutter App", group = "Debug Flutter App", mode = "n" },
  {
    "<leader>F",
    group = "flutter",
    expand = function()
      return require("which-key.extras").expand.buf()
    end,
  },
  { "<leader>Fs", "<cmd>FlutterRun<cr>", desc = "Run Flutter App", group = "Run Flutter App", mode = "n" },
  { "<leader>Fr", "<cmd>FlutterRestart<cr>", desc = "Restart Flutter App", group = "Restart Flutter App", mode = "n" },
  {
    "<leader>t",
    group = "toggle",
    expand = function()
      return require("which-key.extras").expand.buf()
    end,
  },
  {
    "<leader>tt",
    function()
      local cat = require("catppuccin")
      cat.options.transparent_background = not cat.options.transparent_background
      cat.compile()
      vim.cmd.colorscheme(vim.g.colors_name)
    end,
    desc = "ui",
    group = "Toggle Transparent Background",
    mode = "n",
  },
})

-- vim.api.nvim_set_keymap("n", "<leader>tf", "<Plug>PlenaryTestFile", { noremap = false, silent = false })

-- vim.keymap.set("n", "=ap", "ma=ap'a")
-- vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

-- vim.keymap.set("n", "<leader>vwm", function()
--   require("vim-with-me").StartVimWithMe()
-- end)
-- vim.keymap.set("n", "<leader>svwm", function()
--   require("vim-with-me").StopVimWithMe()
-- end)

-- vim.keymap.set("x", "<leader>P", [["_dP]])

-- vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

-- vim.keymap.set("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")

-- vim.keymap.set("n", "<leader>ea", 'oassert.NoError(err, "")<Esc>F";a')

-- vim.keymap.set("n", "<leader>ef", 'oif err != nil {<CR>}<Esc>Olog.Fatalf("error: %s\\n", err.Error())<Esc>jj')

-- vim.keymap.set("n", "<leader>el", 'oif err != nil {<CR>}<Esc>O.logger.Error("error", "error", err)<Esc>F.;i')
