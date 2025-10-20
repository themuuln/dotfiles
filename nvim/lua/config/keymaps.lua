local wk = require("which-key")
local map = vim.keymap.set
local dap = require("dap")

map("n", "<C-m>", "<C-i>", { noremap = true, silent = true })
map("n", "U", ":redo<CR>", { noremap = true, silent = true })
map("i", "jk", "<Esc>", { noremap = true, silent = false })
map("n", "<leader>pv", vim.cmd.Ex)
map("n", "J", "mzJ`z")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-f>", "<C-f>zz")
map("n", "<C-b>", "<C-b>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
-- debugger realted
map("n", "<F5>", dap.continue, { desc = "Debug: Continue / Start" })
map("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
map("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
map("n", "<S-F11>", dap.step_out, { desc = "Debug: Step Out" })
map("n", "<C-S-F5>", dap.restart, { desc = "Debug: Restart" })
map("n", "<S-F5>", function()
  dap.close()
end, { desc = "Debug: Stop" })

-- -- Optional: Visual mode mappings for selecting code to debug (VSCode-like)
-- vim.map("v", "<F5>", function()
--   dap.continue({ execute_args = vim.fn.getenv("DEBUGPY_ARGS") }) -- Adjust for your lang if needed
-- end, { desc = "Debug: Continue selected" }))
--

-- dial
map("n", "+", function()
  require("dial.map").manipulate("increment", "normal")
end)
map("n", "-", function()
  require("dial.map").manipulate("decrement", "normal")
end)
map("v", "+", function()
  require("dial.map").manipulate("increment", "visual")
end)
map("v", "-", function()
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
  { "<leader>Fs", "<cmd>FlutterRun<cr>", desc = "Run Flutter App", mode = "n" },
  {
    "<leader>Fr",
    "<cmd>FlutterRestart<cr>",
    desc = "Restart Flutter App",
    mode = "n",
  },
})
