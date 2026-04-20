vim.keymap.set("n", "<C-m>", "<C-i>", { desc = "Jump to older position in jump list" })
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })
vim.keymap.set("n", "U", ":redo<CR>", { desc = "Redo", noremap = true, silent = true })
vim.keymap.set("n", "<leader>pv", function()
  require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
end, { desc = "Open mini.files" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines keeping cursor position" })

local function format_line_ref(start_line, end_line)
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  if start_line == end_line then
    return tostring(start_line)
  end

  return string.format("%d-%d", start_line, end_line)
end

local function copy_file_with_line_range(opts)
  opts = opts or {}
  local path = vim.fn.expand("%:p")
  if path == "" then
    vim.notify("No file path available for current buffer", vim.log.levels.WARN)
    return
  end

  local line_ref

  if opts.visual then
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")

    if start_line == 0 or end_line == 0 then
      start_line = vim.fn.line("'<")
      end_line = vim.fn.line("'>")
    end

    line_ref = format_line_ref(start_line, end_line)
  else
    line_ref = tostring(vim.fn.line("."))
  end

  local value = string.format("%s:%s", path, line_ref)
  vim.fn.setreg("+", value)
  vim.notify("Copied: " .. value)
end

local function workspace_root()
  if _G.LazyVim and LazyVim.root then
    return LazyVim.root({ normalize = true })
  end
  return vim.fs.normalize(vim.uv.cwd() or ".")
end

local function path_in_workspace(path, root)
  if path == "" then
    return false
  end

  local normalized = vim.fs.normalize(path)
  return normalized == root or vim.startswith(normalized, root .. "/")
end

local function copy_workspace_error_diagnostics()
  local root = workspace_root()
  local diagnostics = vim.tbl_filter(function(diagnostic)
    return path_in_workspace(vim.api.nvim_buf_get_name(diagnostic.bufnr), root)
  end, vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.ERROR }))

  if vim.tbl_isempty(diagnostics) then
    vim.notify("No error diagnostics in current workspace", vim.log.levels.INFO)
    return
  end

  table.sort(diagnostics, function(a, b)
    local path_a = vim.api.nvim_buf_get_name(a.bufnr)
    local path_b = vim.api.nvim_buf_get_name(b.bufnr)

    if path_a == path_b then
      if a.lnum == b.lnum then
        return a.col < b.col
      end

      return a.lnum < b.lnum
    end

    return path_a < path_b
  end)

  local lines = {}
  for _, diagnostic in ipairs(diagnostics) do
    local path = vim.api.nvim_buf_get_name(diagnostic.bufnr)
    local message = diagnostic.message:gsub("\n+", " ")
    table.insert(lines, string.format("%s:%d:%d: %s", path, diagnostic.lnum + 1, diagnostic.col + 1, message))
  end

  local value = table.concat(lines, "\n")
  vim.fn.setreg("+", value)
  vim.notify(string.format("Copied %d workspace error diagnostic(s) from %s", #diagnostics, root))
end

vim.keymap.set("n", "<leader>y", function()
  copy_file_with_line_range()
end, { desc = "Copy file path with line number" })
vim.keymap.set("x", "<leader>y", function()
  local start_pos = vim.fn.getpos("v")
  copy_file_with_line_range({ visual = true })
  vim.schedule(function()
    vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
    vim.api.nvim_win_set_cursor(0, { start_pos[2], math.max(start_pos[3] - 1, 0) })
  end)
end, { desc = "Copy file path with selected line range" })
vim.keymap.set("n", "<leader>ce", copy_workspace_error_diagnostics, { desc = "Copy workspace error diagnostics" })

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
  vim.keymap.set(
    "n",
    "<leader>,",
    "<Cmd>call VSCodeNotify('workbench.action.showAllEditors')<CR>",
    { desc = "Show all editors" }
  )
  vim.keymap.set("n", "<leader><Cr>", "<Cmd>call VSCodeNotify('oil-code.open')<CR>", { desc = "Open oil" })
  vim.keymap.set(
    "n",
    "<leader>tn",
    "<Cmd>call VSCodeNotify('workbench.action.createTerminalEditor')<CR>",
    { desc = "Create terminal" }
  )
  vim.keymap.set(
    "n",
    "<leader>/",
    "<Cmd>call VSCodeNotify('workbench.action.quickTextSearch')<CR>",
    { desc = "Quick text search" }
  )
  vim.keymap.set("n", "<leader>gg", "<Cmd>call VSCodeNotify('lazygit.openLazygit')<CR>", { desc = "Open lazygit" })
  vim.keymap.set(
    "n",
    "gd",
    "<Cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>",
    { desc = "Go to definition" }
  )
  vim.keymap.set("n", "gr", "<Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>", { desc = "Go to references" })
  vim.keymap.set(
    "n",
    "[h",
    "<Cmd>call VSCodeNotify('workbench.action.editor.previousChange')<CR>",
    { desc = "Previous change" }
  )
  vim.keymap.set(
    "n",
    "]h",
    "<Cmd>call VSCodeNotify('workbench.action.editor.nextChange')<CR>",
    { desc = "Next change" }
  )
end
