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
