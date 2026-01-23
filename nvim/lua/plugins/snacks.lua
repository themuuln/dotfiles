return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      notifier = { sort = { "added" } },
      input = {
        icon = "",
        icon_hl = "SnacksInputIcon",
        icon_pos = false,
        prompt_pos = "title",
        win = { style = "input" },
        expand = true,
      },
      image = {
        force = false,
        enabled = true,
        math = { enabled = true },
        doc = { inline = false, float = true },
      },
      quickfile = {
        enabled = true,
      },
      picker = {
        enabled = true,
        ui_select = true,
        previewers = {
          diff = {
            style = "fancy", ---@type "fancy"|"syntax"|"terminal"
            cmd = { "delta" }, -- example for using `delta` as the external diff command
            ---@type vim.wo?|{} window options for the fancy diff preview window
            wo = {
              breakindent = true,
              wrap = true,
              linebreak = true,
              showbreak = "...",
            },
          },
          git = {
            args = {}, -- additional arguments passed to the git command. Useful to set pager options usin `-c ...`
          },
        },
        jump = {
          jumplist = true, -- save the current position in the jumplist
          tagstack = false, -- save the current position in the tagstack
          reuse_win = true, -- reuse an existing window if the buffer is already open
          close = true, -- close the picker when jumping/editing to a location (defaults to true)
          match = false, -- jump to the first match position. (useful for `lines`)
        },
        sources = {
          colorschemes = { layout = { preset = "ivy" } },
          files = {
            sort = function(a, b)
              local a_lib = a.file:find("/lib/") or a.file:find("^lib/")
              local b_lib = b.file:find("/lib/") or b.file:find("^lib/")
              if a_lib and not b_lib then
                return true
              elseif b_lib and not a_lib then
                return false
              end
              return require("snacks.picker.sort").default()(a, b)
            end,
          },
          git_files = {
            sort = function(a, b)
              local a_lib = a.file:find("/lib/") or a.file:find("^lib/")
              local b_lib = b.file:find("/lib/") or b.file:find("^lib/")
              if a_lib and not b_lib then
                return true
              elseif b_lib and not a_lib then
                return false
              end
              return require("snacks.picker.sort").default()(a, b)
            end,
          },
          smart = {
            sort = function(a, b)
              local a_lib = a.file:find("/lib/") or a.file:find("^lib/")
              local b_lib = b.file:find("/lib/") or b.file:find("^lib/")
              if a_lib and not b_lib then
                return true
              elseif b_lib and not a_lib then
                return false
              end
              return require("snacks.picker.sort").default()(a, b)
            end,
          },
          files_with_symbols = {
            multi = { "files", "lsp_symbols" },
            filter = {
              ---@param p snacks.Picker
              ---@param filter snacks.picker.Filter
              transform = function(p, filter)
                local symbol_pattern = filter.pattern:match("^.-@(.*)$")
                -- store the current file buffer
                if filter.source_id ~= 2 then
                  local item = p:current()
                  if item and item.file then
                    filter.meta.buf = vim.fn.bufadd(item.file)
                  end
                end

                if symbol_pattern and filter.meta.buf then
                  filter.pattern = symbol_pattern
                  filter.current_buf = filter.meta.buf
                  filter.source_id = 2
                else
                  filter.source_id = 1
                end
              end,
            },
          },
        },
        actions = {
          yankit = { action = "yank", notify = true },
          toggle_lua = function(p)
            local opts = p.opts --[[@as snacks.picker.grep.Config]]
            opts.ft = not opts.ft and "lua" or nil
            p:find()
          end,
        },
      },
      indent = {
        enabled = false,
      },
      dashboard = {
        sections = {
          { section = "keys", gap = 1, padding = 1 },
          { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          {
            pane = 2,
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git status --short --branch --renames",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
          { section = "startup" },
        },
      },
    },
  },

  {
    "folke/noice.nvim",
    optional = true, -- it's optional in some LazyVim setups
    opts = {
      lsp = {
        hover = { silent = true }, -- Noice won't emit "No information available"
      },
    },
  },
}
