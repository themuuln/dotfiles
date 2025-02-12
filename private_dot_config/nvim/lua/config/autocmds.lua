local maximize_enabled = false

local maximize_group = "MaximizeWindow"
local balance_group = "BalanceWindows"

local function maximize_current_window()
  local win_id = vim.api.nvim_get_current_win()
  vim.cmd("wincmd =")
  vim.api.nvim_win_set_height(win_id, vim.o.lines - 2)
  vim.api.nvim_win_set_width(win_id, vim.o.columns)
end

local function equalize_windows()
  vim.cmd("wincmd =")
end

local function toggle_maximize()
  maximize_enabled = not maximize_enabled
  if maximize_enabled then
    vim.api.nvim_create_augroup(maximize_group, { clear = true })
    vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
      group = maximize_group,
      callback = maximize_current_window,
    })
    vim.api.nvim_create_augroup(balance_group, { clear = true })
    vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
      group = balance_group,
      callback = equalize_windows,
    })
    maximize_current_window()
    print("Window maximize feature enabled")
  else
    pcall(vim.api.nvim_del_augroup_by_name, maximize_group)
    pcall(vim.api.nvim_del_augroup_by_name, balance_group)
    equalize_windows()
    print("Window maximize feature disabled and windows equalized")
  end
end

vim.keymap.set("n", "<leader>wt", toggle_maximize, { desc = "Toggle Maximize Focused Window" })
