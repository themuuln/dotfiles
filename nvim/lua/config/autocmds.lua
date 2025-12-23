-- restore cursor to file position in previous editing session
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
      -- defer centering slightly so it's applied after render
      vim.schedule(function()
        vim.cmd("normal! zz")
      end)
    end
  end,
})

-- open help in vertical split
vim.api.nvim_create_autocmd("FileType", {
  pattern = "help",
  command = "wincmd L",
})

-- auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd("VimResized", {
  command = "wincmd =",
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
