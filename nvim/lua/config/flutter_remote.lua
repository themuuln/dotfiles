local M = {}

local state = {
  initialized = false,
  run = nil,
  watch = nil,
}

local defaults = {
  remote_target = "imac-build",
  simulator_name = "iPhone 17 Pro",
  open_screen_share = 0,
  watch_mode = "sync",
  run_height = 14,
  watch_height = 10,
}

local function config()
  return vim.tbl_deep_extend("force", defaults, vim.g.flutter_remote or {})
end

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = "flutter-remote" })
end

local function is_alive(term)
  return term ~= nil and term.job_id ~= nil and vim.fn.jobwait({ term.job_id }, 0)[1] == -1
end

function M.is_running()
  return is_alive(state.run)
end

local function project_root()
  local current = vim.api.nvim_buf_get_name(0)
  local start = current ~= "" and vim.fs.dirname(current) or (vim.uv.cwd() or vim.fn.getcwd())
  local marker = vim.fs.find({ "pubspec.yaml", ".git" }, { path = start, upward = true })[1]
  if marker then
    return vim.fs.dirname(marker)
  end
  return vim.fs.normalize(vim.uv.cwd() or vim.fn.getcwd())
end

local function script_path(root, script_name)
  local path = root .. "/scripts/" .. script_name
  if vim.uv.fs_stat(path) then
    return path
  end

  notify(string.format("Missing %s in %s", script_name, root), vim.log.levels.ERROR)
  return nil
end

local function build_command(root, script_name, env)
  local script = script_path(root, script_name)
  if not script then
    return nil
  end

  local parts = { "cd " .. vim.fn.shellescape(root) }
  for key, value in pairs(env or {}) do
    if value ~= nil and value ~= "" then
      table.insert(parts, string.format("%s=%s", key, vim.fn.shellescape(tostring(value))))
    end
  end
  table.insert(parts, vim.fn.shellescape(script))
  return table.concat(parts, " ")
end

local function open_terminal(slot, command, title, height)
  if is_alive(state[slot]) then
    notify(title .. " is already running")
    return state[slot]
  end

  vim.cmd(("botright %dsplit"):format(height))
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(0, buf)
  vim.bo[buf].bufhidden = "hide"
  vim.bo[buf].swapfile = false

  local terminal = {
    buf = buf,
    root = project_root(),
    title = title,
  }

  terminal.job_id = vim.fn.termopen(command, {
    on_exit = function(_, code, _)
      vim.schedule(function()
        if state[slot] and state[slot].job_id == terminal.job_id then
          state[slot] = nil
        end

        local level = code == 0 and vim.log.levels.INFO or vim.log.levels.WARN
        notify(string.format("%s exited with code %d", title, code), level)
      end)
    end,
  })

  if terminal.job_id <= 0 then
    notify("Failed to start " .. title, vim.log.levels.ERROR)
    return nil
  end

  state[slot] = terminal
  vim.cmd("startinsert")
  return terminal
end

local function send_run_key(key)
  if not is_alive(state.run) then
    notify("Remote flutter run is not active", vim.log.levels.WARN)
    return
  end

  vim.api.nvim_chan_send(state.run.job_id, key)
end

function M.run()
  local root = project_root()
  local cfg = config()
  local command = build_command(root, "remote_ios_run.sh", {
    REMOTE_TARGET = cfg.remote_target,
    SIMULATOR_NAME = cfg.simulator_name,
    OPEN_SCREEN_SHARE = cfg.open_screen_share,
  })

  if not command then
    return
  end

  open_terminal("run", command, "Flutter Remote Run", cfg.run_height)
end

function M.watch()
  local root = project_root()
  local cfg = config()
  local command = build_command(root, "remote_ios_watch.sh", {
    REMOTE_TARGET = cfg.remote_target,
    WATCH_MODE = cfg.watch_mode,
  })

  if not command then
    return
  end

  open_terminal("watch", command, "Flutter Remote Watch", cfg.watch_height)
end

function M.sync()
  local root = project_root()
  local cfg = config()
  local command = build_command(root, "remote_ios_sync.sh", {
    REMOTE_TARGET = cfg.remote_target,
  })

  if not command then
    return
  end

  open_terminal("watch", command, "Flutter Remote Sync", cfg.watch_height)
end

function M.reload()
  send_run_key("r")
end

function M.restart()
  send_run_key("R")
end

function M.stop()
  if is_alive(state.run) then
    vim.api.nvim_chan_send(state.run.job_id, "q")
  end

  if is_alive(state.watch) then
    vim.api.nvim_chan_send(state.watch.job_id, "\003")
  end
end

function M.setup()
  if state.initialized then
    return
  end

  state.initialized = true

  vim.api.nvim_create_user_command("FlutterRemoteRun", function()
    M.run()
  end, { desc = "Start remote flutter run on iMac" })

  vim.api.nvim_create_user_command("FlutterRemoteWatch", function()
    M.watch()
  end, { desc = "Start remote flutter sync watch" })

  vim.api.nvim_create_user_command("FlutterRemoteSync", function()
    M.sync()
  end, { desc = "Run one remote flutter sync" })

  vim.api.nvim_create_user_command("FlutterRemoteReload", function()
    M.reload()
  end, { desc = "Hot reload remote flutter session" })

  vim.api.nvim_create_user_command("FlutterRemoteRestart", function()
    M.restart()
  end, { desc = "Hot restart remote flutter session" })

  vim.api.nvim_create_user_command("FlutterRemoteStop", function()
    M.stop()
  end, { desc = "Stop remote flutter terminals" })
end

return M
