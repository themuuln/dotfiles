-- local function countLspRefs()
--   local icon = "󰈽" -- CONFIG
--
--   local client = vim.lsp.get_clients({ method = "textDocument/references", bufnr = 0 })[1]
--   if not client then
--     return ""
--   end
--
--   -- prevent multiple requests on still cursor without the need of autocmds
--   local row, col = unpack(vim.api.nvim_win_get_cursor(0))
--   local sameCursorPos = row == vim.b.lspReference_lastRow and col == vim.b.lspReference_lastCol
--
--   if not sameCursorPos then
--     vim.b.lspReference_lastRow, vim.b.lspReference_lastCol = row, col
--
--     local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
--     params.context = { includeDeclaration = true } ---@diagnostic disable-line: inject-field
--     local thisFile = params.textDocument.uri
--
--     client:request("textDocument/references", params, function(error, refs)
--       if error or not refs then -- not on a valid symbol, etc.
--         vim.b.lspReference_count = nil
--         return
--       end
--       local refsInFile = vim
--         .iter(refs)
--         :filter(function(r)
--           return thisFile == r.uri
--         end)
--         :totable()
--       local inFile, inWorkspace = #refsInFile - 1, #refs - 1 -- -1 for current occurrence
--       local text = inFile == inWorkspace and inFile or (inFile .. "(" .. inWorkspace .. ")")
--
--       vim.b.lspReference_count = inWorkspace > 0 and vim.trim(icon .. " " .. text) or nil
--     end)
--   end
--
--   return vim.b.lspReference_count or "" -- returns empty string at first and later the count
-- end

--------------------------------------------------------------------------------

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      ---@type table<string, {updated:number, total:number, enabled: boolean, status:string[]}>
      local mutagen = {}

      local function mutagen_status()
        local cwd = vim.uv.cwd() or "."
        mutagen[cwd] = mutagen[cwd]
          or {
            updated = 0,
            total = 0,
            enabled = vim.fs.find("mutagen.yml", { path = cwd, upward = true })[1] ~= nil,
            status = {},
          }
        local now = vim.uv.now() -- timestamp in milliseconds
        local refresh = mutagen[cwd].updated + 10000 < now
        if #mutagen[cwd].status > 0 then
          refresh = mutagen[cwd].updated + 1000 < now
        end
        if mutagen[cwd].enabled and refresh then
          ---@type {name:string, status:string, idle:boolean}[]
          local sessions = {}
          local lines = vim.fn.systemlist("mutagen project list")
          local status = {}
          local name = nil
          for _, line in ipairs(lines) do
            local n = line:match("^Name: (.*)")
            if n then
              name = n
            end
            local s = line:match("^Status: (.*)")
            if s then
              table.insert(sessions, {
                name = name,
                status = s,
                idle = s == "Watching for changes",
              })
            end
          end
          for _, session in ipairs(sessions) do
            if not session.idle then
              table.insert(status, session.name .. ": " .. session.status)
            end
          end
          mutagen[cwd].updated = now
          mutagen[cwd].total = #sessions
          mutagen[cwd].status = status
          if #sessions == 0 then
            vim.notify("Mutagen is not running", vim.log.levels.ERROR, { title = "Mutagen" })
          end
        end
        return mutagen[cwd]
      end

      local error_color = { fg = Snacks.util.color("DiagnosticError") }
      local ok_color = { fg = Snacks.util.color("DiagnosticInfo") }
      opts.sections = opts.sections or {}
      opts.sections.lualine_x = opts.sections.lualine_x or {}
      table.insert(opts.sections.lualine_x, {
        function()
          local s = mutagen_status()
          local msg = tostring(s.total)
          if #s.status > 0 then
            msg = msg .. " | " .. table.concat(s.status, " | ")
          end
          return (s.total == 0 and "󰋘 " or "󰋙 ") .. msg
        end,
        cond = function()
          return mutagen_status().enabled
        end,
        color = function()
          return (mutagen_status().total == 0 or mutagen_status().status[1]) and error_color or ok_color
        end,
      })

      opts.tabline = opts.tabline or {}
      opts.tabline.lualine_a = opts.tabline.lualine_a or {}
      opts.tabline.lualine_z = opts.tabline.lualine_z or {}
      table.insert(opts.tabline.lualine_a, {
        "buffers",
        mode = 0,
        use_mode_colors = true,
        symbols = { alternate_file = "" },
      })
      table.insert(opts.tabline.lualine_z, {
        "tabs",
        tab_max_length = 40,
        max_length = vim.o.columns / 3,
        mode = 0,
        path = 0,
        use_mode_colors = true,
        show_modified_status = true,
        symbols = { modified = " " },
        fmt = function(name, context)
          local buflist = vim.fn.tabpagebuflist(context.tabnr)
          local winnr = vim.fn.tabpagewinnr(context.tabnr)
          local bufnr = buflist[winnr]
          local mod = vim.fn.getbufvar(bufnr, "&mod")
          return name .. (mod == 1 and " +" or "")
        end,
      })
    end,
  },
}
