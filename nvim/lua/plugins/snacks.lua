return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      notifier = { sort = { "added" } },
      image = {
        force = false,
        enabled = true,
        math = { enabled = true },
        doc = { inline = true, float = true },
      },
      picker = {
        enabled = true,
        previewers = {
          diff = { builtin = false },
          git = { builtin = false },
        },
        sources = {
          explorer = {
            layout = {
              preset = "sidebar",
              preview = { main = true, enabled = false },
            },
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
        -- win = {
        --   list = {
        --     keys = {
        --       ["<c-i>"] = { "toggle_input", mode = { "n", "i" } },
        --     },
        --   },
        --   input = {
        --     keys = {
        --       ["<c-l>"] = { "toggle_lua", mode = { "n", "i" } },
        --       ["<c-i>"] = { "toggle_input", mode = { "n", "i" } },
        --       -- ["<c-t>"] = { "edit_tab", mode = { "n", "i" } },
        --       -- ["<c-t>"] = { "yankit", mode = { "n", "i" } },
        --       -- ["<Esc>"] = { "close", mode = { "n", "i" } },
        --     },
        --   },
        -- },
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
        chunk = { enabled = true },
      },
      dashboard = {
        sections = {
          { icon = " ", title = "Recent", section = "recent_files", indent = 0, padding = 1 },
          function()
            local in_git = Snacks.git.get_root() ~= nil
            local cmds = {
              {
                icon = " ",
                title = "Git Status",
                cmd = "git --no-pager diff --stat -B -M -C",
              },
            }
            return vim.tbl_map(function(cmd)
              return vim.tbl_extend("force", {
                section = "terminal",
                enabled = in_git,
                padding = 0,
                ttl = 5 * 60,
                indent = 0,
              }, cmd)
            end, cmds)
          end,
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
