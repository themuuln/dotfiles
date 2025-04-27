local wk = require("which-key")
local keymap = vim.keymap

keymap.set("n", "<C-m>", "<C-i>", { noremap = true, silent = true })
keymap.set("n", "U", ":redo<CR>", { noremap = true, silent = true })
keymap.set("i", "jk", "<Esc>", { noremap = true, silent = false })
keymap.set("n", "<leader>pv", vim.cmd.Ex)
keymap.set("n", "J", "mzJ`z")
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

-- dial
keymap.set("n", "+", function()
  require("dial.map").manipulate("increment", "normal")
end)
keymap.set("n", "-", function()
  require("dial.map").manipulate("decrement", "normal")
end)
keymap.set("v", "+", function()
  require("dial.map").manipulate("increment", "visual")
end)
keymap.set("v", "-", function()
  require("dial.map").manipulate("decrement", "visual")
end)

wk.add({
  { "<leader>dd", "<cmd>FlutterDebug<cr>", desc = "Debug Flutter App", group = "Debug Flutter App", mode = "n" },
  {
    "<leader>F",
    group = "flutter",
    icon = "󱗆",
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

-- keymap.set("n", "=ap", "ma=ap'a")
-- keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")
-- keymap.set("n", "<leader>vwm", function()
--   require("vim-with-me").StartVimWithMe()
-- end)
-- keymap.set("n", "<leader>svwm", function()
--   require("vim-with-me").StopVimWithMe()
-- end)
-- keymap.set("x", "<leader>P", [["_dP]])
-- keymap.set({ "n", "v" }, "<leader>d", '"_d')
-- keymap.set("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")
-- keymap.set("n", "<leader>ea", 'oassert.NoError(err, "")<Esc>F";a')
-- keymap.set("n", "<leader>ef", 'oif err != nil {<CR>}<Esc>Olog.Fatalf("error: %s\\n", err.Error())<Esc>jj')
-- keymap.set("n", "<leader>el", 'oif err != nil {<CR>}<Esc>O.logger.Error("error", "error", err)<Esc>F.;i')
