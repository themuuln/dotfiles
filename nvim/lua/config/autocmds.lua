local M = {}

-- Configuration with defaults
M.config = {
  options = {
    snippet_dir = vim.fn.stdpath("config") .. "/snippets",
    debug = false,
  },
}

-- Logger utility
local function log(msg, level)
  if not M.config.options.debug then
    return
  end
  level = level or "info"
  vim.notify("[CRSnip] " .. msg, vim.log.levels[string.upper(level)])
end

-- Ensure directory exists
local function ensure_dir(dir)
  local stat = vim.loop.fs_stat(dir)
  if not stat then
    log("Creating directory: " .. dir, "info")
    vim.fn.mkdir(dir, "p")
  end
end

-- Read existing snippets from file
local function read_snippets(file_path)
  local snippets = {}
  local file = io.open(file_path, "r")
  if file then
    local content = file:read("*a")
    file:close()
    if content and content ~= "" then
      local ok, decoded = pcall(vim.fn.json_decode, content)
      if ok and type(decoded) == "table" then
        if vim.tbl_islist(decoded) then -- Array format (old)
          for _, snippet in ipairs(decoded) do
            if snippet.name then
              snippets[snippet.name] = {
                prefix = snippet.prefix,
                body = snippet.body,
                description = snippet.description,
              }
            end
          end
        else -- Object format (new)
          snippets = decoded
        end
      else
        log("Error decoding JSON, starting a new snippet file.", "warn")
      end
    end
  end
  return snippets
end

-- Format JSON nicely
local function format_json(obj)
  -- Convert to JSON with indentation for better readability
  local json = vim.fn.json_encode(obj)
  -- Prettify the JSON (basic approach)
  json = json:gsub('{"', '{\n  "')
  json = json:gsub(',"', ',\n  "')
  json = json:gsub("}}", "}\n}")
  json = json:gsub("]}", "]\n}")
  return json
end

-- Create a snippet
M.create_snippet = function(opts)
  opts = opts or {}
  local snippet_text = {}

  -- Get selected text if in visual mode
  if opts.line1 and opts.line2 then
    snippet_text = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
  end

  -- Get snippet metadata
  local prefix = vim.fn.input("Snippet Prefix: ")
  if prefix == "" then
    vim.api.nvim_err_writeln("Snippet prefix cannot be empty!")
    return
  end

  local name = vim.fn.input("Snippet Name: ")
  if name == "" then
    name = prefix -- Use prefix as name if not provided
  end

  local description = vim.fn.input("Snippet Description: ")

  -- Determine language
  local language = vim.bo.filetype
  if not language or language == "" then
    local langs = { "typescript", "javascript", "dart", "lua", "python" }
    local choices = { "Select language:" }
    for i, lang in ipairs(langs) do
      table.insert(choices, i .. ". " .. lang)
    end

    local choice = vim.fn.inputlist(choices)
    if choice < 1 or choice > #langs then
      vim.api.nvim_err_writeln("Invalid language choice!")
      return
    end
    language = langs[choice]
  end

  -- Get snippet content if not provided through selection
  if #snippet_text == 0 then
    vim.api.nvim_out_write("Enter snippet code (finish with a line containing only '.')\n")
    while true do
      local line = vim.fn.input("> ")
      if line == "." then
        break
      end
      table.insert(snippet_text, line)
    end

    if #snippet_text == 0 then
      vim.api.nvim_err_writeln("Snippet body cannot be empty!")
      return
    end
  end

  -- Ensure snippet directory exists
  ensure_dir(vim.fn.stdpath("config") .. "/snippets")

  -- Get the file path
  local file_path = M.config.options.snippet_dir .. "/" .. language .. ".json"

  -- Read existing snippets
  local snippets = read_snippets(file_path)

  -- Check if snippet already exists
  local existed = snippets[name] ~= nil

  -- Add new snippet
  snippets[name] = {
    prefix = prefix,
    body = snippet_text,
    description = description,
  }

  -- Write snippets to file
  local file_write, err = io.open(file_path, "w")
  if not file_write then
    vim.api.nvim_err_writeln("Error opening file for writing: " .. (err or "unknown error"))
    return
  end

  local json_snippets = format_json(snippets)
  file_write:write(json_snippets)
  file_write:close()

  local action = existed and "overridden" or "added"
  vim.api.nvim_echo({
    { "✅ Snippet ", "Normal" },
    { name, "Special" },
    { " " .. action .. " to ", "Normal" },
    { file_path, "Directory" },
  }, true, {})
end

-- Plugin setup function
M.setup = function(opts)
  M.config.options = vim.tbl_deep_extend("force", M.config.options, opts or {})

  -- Create command to create snippet
  vim.api.nvim_create_user_command("CreateSnippet", function(cmd_opts)
    M.create_snippet({
      line1 = cmd_opts.line1,
      line2 = cmd_opts.line2,
    })
  end, {
    desc = "Create a new snippet",
    range = true,
  })

  -- Create additional command for use with visual mode
  vim.api.nvim_create_user_command("CRSnip", function(cmd_opts)
    M.create_snippet({
      line1 = cmd_opts.line1,
      line2 = cmd_opts.line2,
    })
  end, {
    desc = "Create a new snippet",
    range = true,
  })

  log("CRSnip initialized with snippet_dir: " .. M.config.options.snippet_dir)
end

return M
