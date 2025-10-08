return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- statuscolumn = { folds = { open = true } },
    notifier = { sort = { "added" } },
    -- image = {
    --   force = false,
    --   enabled = true,
    --   math = { enabled = true },
    --   doc = { inline = true, float = true },
    -- },
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
        -- files_with_symbols = {
        --   multi = { "files", "lsp_symbols" },
        --   filter = {
        --     ---@param p snacks.Picker
        --     ---@param filter snacks.picker.Filter
        --     transform = function(p, filter)
        --       local symbol_pattern = filter.pattern:match("^.-@(.*)$")
        --       -- store the current file buffer
        --       if filter.source_id ~= 2 then
        --         local item = p:current()
        --         if item and item.file then
        --           filter.meta.buf = vim.fn.bufadd(item.file)
        --         end
        --       end
        --
        --       if symbol_pattern and filter.meta.buf then
        --         filter.pattern = symbol_pattern
        --         filter.current_buf = filter.meta.buf
        --         filter.source_id = 2
        --       else
        --         filter.source_id = 1
        --       end
        --     end,
        --   },
        -- },
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
      -- actions = {
      --   yankit = { action = "yank", notify = true },
      --   toggle_lua = function(p)
      --     local opts = p.opts --[[@as snacks.picker.grep.Config]]
      --     opts.ft = not opts.ft and "lua" or nil
      --     p:find()
      --   end,
      -- },
    },
    indent = {
      enabled = false,
      chunk = { enabled = true },
    },
    -- dashboard = {
    --   width = 60,
    --   row = nil, -- dashboard position. nil for center
    --   col = nil, -- dashboard position. nil for center
    --   pane_gap = 4, -- empty columns between vertical panes
    --   autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
    --   -- These settings are used by some built-in sections
    --   preset = {
    --     -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
    --     ---@type fun(cmd:string, opts:table)|nil
    --     pick = nil,
    --     -- Used by the `keys` section to show keymaps.
    --     -- Set your custom keymaps here.
    --     -- When using a function, the `items` argument are the default keymaps.
    --     ---@type snacks.dashboard.Item[]
    --     keys = {
    --       { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
    --       { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
    --       { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
    --       { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
    --       {
    --         icon = " ",
    --         key = "c",
    --         desc = "Config",
    --         action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
    --       },
    --       { icon = " ", key = "s", desc = "Restore Session", section = "session" },
    --       { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
    --       { icon = " ", key = "q", desc = "Quit", action = ":qa" },
    --     },
    --     -- Used by the `header` section
    --     --         header = [[
    --     --  ___________.._______
    --     -- | .__________))______|
    --     -- | | / /      ||
    --     -- | |/ /       ||
    --     -- | | /        ||.-''.
    --     -- | |/         |/  _  \
    --     -- | |          ||  `/,|
    --     -- | |          (\\`_.'
    --     -- | |         .-`--'.
    --     -- | |        /Y . . Y\
    --     -- | |       // |   | \\
    --     -- | |      //  | . |  \\
    --     -- | |     ')   |   |   (`
    --     -- | |          ||'||
    --     -- | |          || ||
    --     -- | |          || ||
    --     -- | |          || ||
    --     -- | |         / | | \
    --     -- """"""""""|_`-' `-' |"""|
    --     -- |"|"""""""\ \       '"|"|
    --     -- | |        \ \        | |
    --     -- : :         \ \       : :  sk
    --     -- . .          `'       . .
    --     -- ]],
    --   },
    --   -- item field formatters
    --   formats = {
    --     icon = function(item)
    --       if item.file and item.icon == "file" or item.icon == "directory" then
    --         return M.icon(item.file, item.icon)
    --       end
    --       return { item.icon, width = 2, hl = "icon" }
    --     end,
    --     footer = { "%s", align = "center" },
    --     header = { "%s", align = "center" },
    --     file = function(item, ctx)
    --       local fname = vim.fn.fnamemodify(item.file, ":~")
    --       fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
    --       if #fname > ctx.width then
    --         local dir = vim.fn.fnamemodify(fname, ":h")
    --         local file = vim.fn.fnamemodify(fname, ":t")
    --         if dir and file then
    --           file = file:sub(-(ctx.width - #dir - 2))
    --           fname = dir .. "/…" .. file
    --         end
    --       end
    --       local dir, file = fname:match("^(.*)/(.+)$")
    --       return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
    --     end,
    --   },
    --   sections = {
    --     { section = "header" },
    --     { section = "keys", gap = 1, padding = 1 },
    --     { section = "startup" },
    --   },
    -- },
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
              pane = 1,
              -- width = 200,
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
}
