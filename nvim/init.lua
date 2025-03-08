require("config.lazy")

-- c  "l   yoprint('^[pa: ${^[pa}^[A;^[
------------------
-- CUSTOM MACRO --
------------------

local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)

vim.api.nvim_create_augroup("JSLogMacro", { clear = true })
vim.api.nvim_create_augroup("DartLogMacro", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = "JSLogMacro",
  pattern = { "javascript", "typescript" },
  callback = function()
    vim.fn.setreg("l", "yoconsole.log('" .. esc .. "pa:" .. esc .. "la, " .. esc .. "pl")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = "DartLogMacro",
  pattern = { "dart" },
  callback = function()
    vim.fn.setreg("l", "yoprint('" .. esc .. "pa ${" .. esc .. "la}" .. esc .. "pl")
  end,
})
