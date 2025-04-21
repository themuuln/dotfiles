-- DOCS https://github.com/nvim-lualine/lualine.nvim#default-configuration-----------------------------------------------------------------------------

---Adds a component lualine was already set up. This enables lazy-loading
---plugins that add statusline components.
---(Accessed via `vim.g`, as this file's exports are used by `lazy.nvim`.)
---@param whichBar "tabline"|"winbar"|"inactive_winbar"|"sections"
---@param whichSection "lualine_a"|"lualine_b"|"lualine_c"|"lualine_x"|"lualine_y"|"lualine_z"
---@param component function|table the component forming the lualine
---@param where "after"|"before"? defaults to "after"
vim.g.lualineAdd = function(whichBar, whichSection, component, where)
  local componentObj = type(component) == "table" and component or { component }
  local sectionConfig = require("lualine").get_config()[whichBar][whichSection] or {}
  local pos = where == "before" and 1 or #sectionConfig + 1
  table.insert(sectionConfig, pos, componentObj)
  require("lualine").setup({ [whichBar] = { [whichSection] = sectionConfig } })
end

---Asynchronously count LSP references, returns empty string until async is
---done. When done, returns the number of references in the current file, and in
---brackets the number of references in the workspace (if that number is
---different from the references in the current file).
local function countLspRefs()
  local icon = "󰈿" -- CONFIG

  local client = vim.lsp.get_clients({ method = "textDocument/references", bufnr = 0 })[1]
  if not client then
    return ""
  end

  -- prevent multiple requests on still cursor without the need of autocmds
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local sameCursorPos = row == vim.b.lspReference_lastRow and col == vim.b.lspReference_lastCol

  if not sameCursorPos then
    vim.b.lspReference_lastRow, vim.b.lspReference_lastCol = row, col

    local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
    params.context = { includeDeclaration = true } ---@diagnostic disable-line: inject-field
    local thisFile = params.textDocument.uri

    client:request("textDocument/references", params, function(error, refs)
      if error or not refs then -- not on a valid symbol, etc.
        vim.b.lspReference_count = nil
        return
      end
      local refsInFile = vim
        .iter(refs)
        :filter(function(r)
          return thisFile == r.uri
        end)
        :totable()
      local inFile, inWorkspace = #refsInFile - 1, #refs - 1 -- -1 for current occurrence
      local text = inFile == inWorkspace and inFile or (inFile .. "(" .. inWorkspace .. ")")

      vim.b.lspReference_count = inWorkspace > 0 and vim.trim(icon .. " " .. text) or nil
    end)
  end

  return vim.b.lspReference_count or "" -- returns empty string at first and later the count
end

--------------------------------------------------------------------------------

return {
  "nvim-lualine/lualine.nvim",
  event = "UIEnter",
  opts = {
    options = {
      globalstatus = true,
      always_divide_middle = false,
      ignore_focus = { "snacks_input", "snacks_picker_input" },
    },
    sections = {
      lualine_a = {
        lualine_a = {
          {
            "tabs",
            tab_max_length = 40, -- Maximum width of each tab. The content will be shorten dynamically (example: apple/orange -> a/orange)
            max_length = vim.o.columns / 3, -- Maximum width of tabs component.
            -- Note:
            -- It can also be a function that returns
            -- the value of `max_length` dynamically.
            mode = 0, -- 0: Shows tab_nr
            -- 1: Shows tab_name
            -- 2: Shows tab_nr + tab_name

            path = 0, -- 0: just shows the filename
            -- 1: shows the relative path and shorten $HOME to ~
            -- 2: shows the full path
            -- 3: shows the full path and shorten $HOME to ~

            -- Automatically updates active tab color to match color of other components (will be overidden if buffers_color is set)
            use_mode_colors = false,

            tabs_color = {
              -- Same values as the general color option can be used here.
              active = "lualine_{section}_normal", -- Color for active tab.
              inactive = "lualine_{section}_inactive", -- Color for inactive tab.
            },

            show_modified_status = true, -- Shows a symbol next to the tab name if the file has been modified.
            symbols = {
              modified = "[+]", -- Text to show when the file is modified.
            },

            fmt = function(name, context)
              -- Show + if buffer is modified in tab
              local buflist = vim.fn.tabpagebuflist(context.tabnr)
              local winnr = vim.fn.tabpagewinnr(context.tabnr)
              local bufnr = buflist[winnr]
              local mod = vim.fn.getbufvar(bufnr, "&mod")

              return name .. (mod == 1 and " +" or "")
            end,
          },
        },
        -- {
        --   "fileformat",
        --   symbols = {
        --     unix = "", -- e712
        --     dos = "", -- e70f
        --     mac = "", -- e711
        --   },
        -- },
        -- {
        --   "branch",
        --   icon = "",
        --   cond = function() -- only if not on main or master
        --     local curBranch = require("lualine.components.branch.git_branch").get_branch()
        --     return curBranch ~= "main" and curBranch ~= "master" and vim.bo.buftype == ""
        --   end,
        -- },
        -- { -- file name & icon
        --   function()
        --     local maxLength = 30
        --     local name = vim.fs.basename(vim.api.nvim_buf_get_name(0))
        --     local modified = vim.api.nvim_buf_get_option(0, "modified")
        --
        --     if name == "" then
        --       name = vim.bo.ft
        --     end
        --     if name == "" then
        --       name = "---"
        --     end
        --
        --     local displayName = #name < maxLength and name or vim.trim(name:sub(1, maxLength)) .. "…"
        --     if modified then
        --       displayName = displayName .. " ●"
        --     end
        --
        --     local ok, icons = pcall(require, "mini.icons")
        --     if not ok then
        --       return displayName
        --     end
        --     local icon, _, isDefault = icons.get("file", name)
        --     if isDefault then
        --       icon = icons.get("filetype", vim.bo.ft)
        --     end
        --
        --     return icon .. " " .. displayName
        --   end,
        -- },
      },
      lualine_b = {
        { "buffers" },
      },
      lualine_c = {
        -- { require("personal-plugins.alt-alt").mostChangedFileStatusbar },
        { countLspRefs },
      },
      lualine_x = {
        { -- recording status
          function()
            return ("Recording [%s]…"):format(vim.fn.reg_recording())
          end,
          icon = "󰑊",
          cond = function()
            return vim.fn.reg_recording() ~= ""
          end,
          color = "ErrorMsg",
        },
        { -- Quickfix counter
          function()
            local qf = vim.fn.getqflist({ idx = 0, title = true, items = true })
            if #qf.items == 0 then
              return ""
            end
            return (" %d/%d (%s)"):format(qf.idx, #qf.items, qf.title)
          end,
        },
        {
          "fileformat",
          icon = "󰌑",
          cond = function()
            return vim.bo.fileformat ~= "unix"
          end,
        },
        {
          "diagnostics",
          symbols = { error = "󰅚 ", warn = " ", info = "󰋽 ", hint = "󰘥 " },
          cond = function()
            return vim.diagnostic.is_enabled({ bufnr = 0 })
          end,
        },
        {
          "lsp_status",
          icon = "",
          ignore_lsp = { "typos_lsp", "efm" },
          -- only show component if LSP is active
          cond = function()
            if vim.g.lualine_lsp_active ~= nil then
              return vim.g.lualine_lsp_active
            end
            vim.g.lualine_lsp_active = false
            -- ^ so autocmd is only created once

            vim.api.nvim_create_autocmd("LspProgress", {
              desc = "User: Hide LSP progress component after 2s",
              callback = function()
                vim.g.lualine_lsp_active = true
                vim.defer_fn(function()
                  vim.g.lualine_lsp_active = false
                end, 2000)
              end,
            })
          end,
        },
      },
      lualine_y = {
        {
          function()
            return vim.api.nvim_buf_line_count(0) .. " "
          end,
          cond = function()
            return vim.bo.buftype == ""
          end,
        },
        {
          function()
            return vim.o.foldlevel
          end,
          icon = "󰘖",
          cond = function()
            return vim.o.foldlevel > 0 and vim.o.foldlevel ~= 99
          end,
        },
      },
      lualine_z = {
        { "selectioncount", icon = "󰒆" },
        { "location" },
      },
    },
  },
}
