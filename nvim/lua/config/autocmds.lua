-- show cursor line only in active window
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  callback = function()
    if vim.w.auto_cursorline then
      vim.wo.cursorline = true
      vim.w.auto_cursorline = nil
    end
  end,
})
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  callback = function()
    if vim.wo.cursorline then
      vim.w.auto_cursorline = true
      vim.wo.cursorline = false
    end
  end,
})

-- backups
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   group = vim.api.nvim_create_augroup("better_backup", { clear = true }),
--   callback = function(event)
--     local file = vim.uv.fs_realpath(event.match) or event.match
--     local backup = vim.fn.fnamemodify(file, ":p:~:h")
--     backup = backup:gsub("[/\\]", "%%")
--     vim.go.backupext = backup
--   end,
-- })

vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- vim.api.nvim_create_autocmd("QuickFixCmdPost", {
--   callback = function()
--     vim.cmd([[Trouble qflist open]])
--   end,
-- })

-- vim.api.nvim_create_autocmd("BufRead", {
--   callback = function(ev)
--     if vim.bo[ev.buf].buftype == "quickfix" then
--       vim.schedule(function()
--         vim.cmd([[cclose]])
--         vim.cmd([[Trouble qflist open]])
--       end)
--     end
--   end,
-- })

-- kulala autocmds for env
local last_env = nil
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local filetype = vim.bo.filetype
    if filetype ~= "http" then
      return
    end

    local filename = vim.fn.expand("%:t"):lower()
    local kulala = require("kulala")

    local selected_env = filename:match("sso") and "devsso" or "dev"

    if selected_env ~= last_env then
      kulala.set_selected_env(selected_env)

      vim.notify("🌱 Kulala: Switched to `" .. selected_env .. "` environment", vim.log.levels.INFO, {
        title = "kulala.nvim",
      })

      last_env = selected_env
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "http",
  callback = function()
    vim.keymap.set("n", "<CR>", function()
      require("kulala").run()
    end, { buffer = true, desc = "Run HTTP request with kulala" })
  end,
})

-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     if client.name == "biome" then
--       vim.api.nvim_create_autocmd("BufWritePre", {
--         group = vim.api.nvim_create_augroup("BiomeFixAll", { clear = true }),
--         callback = function()
--           vim.lsp.buf.code_action({
--             context = {
--               only = { "source.fixAll.biome" },
--               diagnostics = {},
--             },
--             apply = true,
--           })
--         end,
--       })
--     end
--   end,
-- })
