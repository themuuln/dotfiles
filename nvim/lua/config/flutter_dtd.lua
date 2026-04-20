local M = {}

local islist = vim.islist or vim.tbl_islist
local listener_name = "flutter-dtd"
local wrapper_path = vim.fs.normalize(vim.fn.expand("~/bin/flutter-run-dtd"))

local function is_flutter_launch(config)
  return type(config) == "table"
    and config.type == "dart"
    and config.request == "launch"
    and type(config.flutterSdkPath) == "string"
    and config.flutterSdkPath ~= ""
end

local function has_arg(args, value)
  return islist(args) and vim.tbl_contains(args, value)
end

local function normalize_tool_args(config)
  local tool_args = islist(config.toolArgs) and vim.deepcopy(config.toolArgs) or {}

  if islist(config.args) and #config.args > 0 then
    vim.list_extend(tool_args, config.args)
    config.args = nil
  end

  if not has_arg(tool_args, "--pid-file=.flutter.pid") then
    table.insert(tool_args, "--pid-file=.flutter.pid")
  end

  config.toolArgs = tool_args
  return config
end

function M.setup()
  if M.initialized then
    return
  end

  local ok, dap = pcall(require, "dap")
  if not ok then
    return
  end

  dap.listeners.on_config[listener_name] = function(config)
    if not is_flutter_launch(config) then
      return config
    end

    config = normalize_tool_args(vim.deepcopy(config))

    if vim.fn.executable(wrapper_path) == 1 then
      config.customTool = wrapper_path
      config.customToolReplacesArgs = 1
    end

    return config
  end

  M.initialized = true
end

return M
