local function countLspRefs()
  local icon = "󰈽" -- CONFIG

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
  opts = function()
    local icons = LazyVim.config.icons
    local opts = {
      options = {
        globalstatus = true,
        always_divide_middle = false,
        ignore_focus = { "snacks_input", "snacks_picker_input" },
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      tabline = {
        lualine_a = {
          {
            "branch",
            icon = "",
            cond = function()
              local curBranch = require("lualine.components.branch.git_branch").get_branch()
              return curBranch ~= "main" and curBranch ~= "master" and vim.bo.buftype == ""
            end,
          },
          {
            "tabs",
            tab_max_length = 40, -- Maximum width of each tab. The content will be shorten dynamically (example: apple/orange -> a/orange)
            max_length = vim.o.columns / 3, -- Maximum width of tabs component.
            mode = 0,
            -- 0: Shows tab_nr
            -- 1: Shows tab_name
            -- 2: Shows tab_nr + tab_name

            path = 0, -- 0: just shows the filename
            -- 1: shows the relative path and shorten $HOME to ~
            -- 2: shows the full path
            -- 3: shows the full path and shorten $HOME to ~
            use_mode_colors = true,
            show_modified_status = true,
            symbols = {
              modified = " ",
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
        -- lualine_b = { { LazyVim.lualine.pretty_path() } },
        lualine_c = {
          -- LazyVim.lualine.root_dir(),
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        },
      },
      sections = {
        lualine_a = {},
        lualine_b = {
          {
            "buffers",
            hide_filename_extension = true,

            -- 0: Shows buffer name
            -- 1: Shows buffer index
            -- 2: Shows buffer name + buffer index
            -- 3: Shows buffer number
            -- 4: Shows buffer name + buffer number
            mode = 0,

            use_mode_colors = true,
            symbols = { alternate_file = "" },
          },
        },
        lualine_c = {
          -- { countLspRefs }
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
          { "diff" },
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
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
          -- { "progress" },
          { "location" },
        },
      },
    }

    if vim.g.trouble_lualine and LazyVim.has("trouble.nvim") then
      local trouble = require("trouble")
      local symbols = trouble.statusline({
        mode = "symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        hl_group = "lualine_c_normal",
      })

      table.insert(opts.tabline.lualine_c, {

        symbols and symbols.get,
        cond = function()
          return vim.b.trouble_lualine ~= false and symbols.has()
        end,
      })
    end

    return opts
  end,
}
