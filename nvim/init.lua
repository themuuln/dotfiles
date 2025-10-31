if vim.env.VSCODE then
  vim.g.vscode = true
end

require("config.lazy")

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
