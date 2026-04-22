local M = {}

local function cwd()
  return vim.fs.normalize(vim.uv.cwd() or vim.fn.getcwd())
end

local function root()
  if _G.LazyVim and LazyVim.root then
    return LazyVim.root({ normalize = true })
  end
  return cwd()
end

local function selection_query()
  local mode = vim.fn.mode()
  if not mode:match("[vV\22]") then
    return nil
  end

  local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = mode })
  local text = table.concat(lines, "\n"):gsub("%s+", " ")
  text = vim.trim(text)
  return text ~= "" and text or nil
end

local function current_query()
  return selection_query() or vim.fn.expand("<cword>")
end

function M.find_files_root()
  require("fff").find_files_in_dir(root())
end

function M.find_files_cwd()
  require("fff").find_files_in_dir(cwd())
end

function M.find_config_files()
  require("fff").find_files_in_dir(vim.fn.stdpath("config"))
end

function M.live_grep_root(opts)
  opts = vim.tbl_extend("force", { cwd = root(), title = "Live Grep" }, opts or {})
  require("fff").live_grep(opts)
end

function M.live_grep_cwd(opts)
  opts = vim.tbl_extend("force", { cwd = cwd(), title = "Live Grep (cwd)" }, opts or {})
  require("fff").live_grep(opts)
end

function M.grep_query_root()
  M.live_grep_root({ query = current_query() })
end

function M.grep_query_cwd()
  M.live_grep_cwd({ query = current_query() })
end

return M
