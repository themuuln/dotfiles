-- open help in vertical split
vim.api.nvim_create_autocmd("FileType", {
  pattern = "help",
  command = "wincmd L",
})

vim.api.nvim_create_autocmd("VimResized", {
  command = "wincmd =",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.spell = false
  end,
})

-- -- kulala autocmds for env
-- local last_env = nil
-- vim.api.nvim_create_autocmd("BufEnter", {
--   callback = function()
--     local filetype = vim.bo.filetype
--     if filetype ~= "http" then
--       return
--     end
--
--     local filename = vim.fn.expand("%:t"):lower()
--     local kulala = require("kulala")
--
--     local selected_env = filename:match("sso") and "devsso" or "dev"
--
--     if selected_env ~= last_env then
--       kulala.set_selected_env(selected_env)
--
--       vim.notify("🌱 Kulala: Switched to `" .. selected_env .. "` environment", vim.log.levels.INFO, {
--         title = "kulala.nvim",
--       })
--
--       last_env = selected_env
--     end
--   end,
-- })

-- Open gf in the previous window if in REPL
vim.keymap.set("n", "gf", function()
  local target = vim.fn.expand("<cfile>")
  if vim.bo.filetype == "dap-repl" or vim.bo.filetype == "terminal" then
    vim.cmd("wincmd p") -- Jump to previous window
    vim.cmd("edit " .. target)
  else
    vim.cmd("normal! gf")
  end
end, { desc = "Smart gf for REPL" })

------------------
-- CUSTOM MACRO --
------------------

local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)

vim.api.nvim_create_augroup("JSLogMacro", { clear = true })
vim.api.nvim_create_augroup("DartLogMacro", { clear = true })

-- select variable, `@l` to print that data on the next line
vim.api.nvim_create_autocmd("FileType", {
  group = "JSLogMacro",
  pattern = { "javascript", "typescript", "typescriptreact", "javascriptreact" },
  callback = function()
    vim.fn.setreg("l", "yoconsole.log('" .. esc .. "pa:" .. esc .. "la, " .. esc .. "pl")
  end,
})

-- select variable, `@l` to log that data on the next line
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("DartLogMacro", { clear = true }),
  pattern = "dart",
  callback = function()
    vim.fn.setreg("l", "yo" .. "log(" .. esc .. 'pa, prefix: "' .. esc .. 'pa");' .. esc)
  end,
})
