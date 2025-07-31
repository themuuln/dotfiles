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
  "nvim-lualine/lualine.nvim",
  event = "UIEnter",
  opts = function()
    local opts = {
      options = {
        globalstatus = true,
        always_divide_middle = false,
        ignore_focus = { "snacks_input", "snacks_picker_input" },
        -- component_separators = { left = "", right = "" },
        -- section_separators = { left = "", right = "" },
      },
      -- tabline = {
      --   lualine_a = {
      --     {
      --       "buffers",
      --       mode = 0,
      --       use_mode_colors = true,
      --       symbols = { alternate_file = "" },
      --     },
      --   },
      --   lualine_z = {
      --     {
      --       "tabs",
      --       tab_max_length = 40,
      --       max_length = vim.o.columns / 3,
      --       mode = 0,
      --       -- 0: Shows tab_nr
      --       -- 1: Shows tab_name
      --       -- 2: Shows tab_nr + tab_name
      --       path = 0, -- 0: just shows the filename
      --       -- 1: shows the relative path and shorten $HOME to ~
      --       -- 2: shows the full path
      --       -- 3: shows the full path and shorten $HOME to ~
      --       use_mode_colors = true,
      --       show_modified_status = true,
      --       symbols = { modified = " " },
      --       fmt = function(name, context)
      --         -- Show + if buffer is modified in tab
      --         local buflist = vim.fn.tabpagebuflist(context.tabnr)
      --         local winnr = vim.fn.tabpagewinnr(context.tabnr)
      --         local bufnr = buflist[winnr]
      --         local mod = vim.fn.getbufvar(bufnr, "&mod")
      --
      --         return name .. (mod == 1 and " +" or "")
      --       end,
      --     },
      --   },
      -- },
    }

    return opts
  end,
}
