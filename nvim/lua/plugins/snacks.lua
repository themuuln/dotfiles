return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.keymap
    -- keys = {
    --   {
    --     "<leader><space>",
    --     function()
    --       Snacks.picker.smart(customTelescope)
    --     end,
    --     desc = "Smart Find Files",
    --   },
    --   {
    --     "<leader>e",
    --     function()
    --       Snacks.explorer({ layout = { preset = "sidebar" } })
    --     end,
    --     desc = "File Explorer",
    --   },
    --
    --   -- Top Pickers & Explorer
    --   {
    --     "<leader><space>",
    --     function()
    --       Snacks.picker.smart(customTelescope)
    --     end,
    --     desc = "Smart Find Files",
    --   },
    --   {
    --     "<leader>,",
    --     function()
    --       Snacks.picker.buffers(customTelescope)
    --     end,
    --     desc = "Buffers",
    --   },
    --   {
    --     "<leader>:",
    --     function()
    --       Snacks.picker.command_history(customTelescope)
    --     end,
    --     desc = "Command History",
    --   },
    --   {
    --     "<leader>n",
    --     function()
    --       Snacks.picker.notifications(customTelescope)
    --     end,
    --     desc = "Notification History",
    --   },
    --
    --   -- find
    --   {
    --     "<leader>fb",
    --     function()
    --       Snacks.picker.buffers(customTelescope)
    --     end,
    --     desc = "Buffers",
    --   },
    --   {
    --     "<leader>fc",
    --     function()
    --       Snacks.picker.files(vim.tbl_extend("force", { cwd = vim.fn.stdpath("config") }, customTelescope))
    --     end,
    --     desc = "Find Config File",
    --   },
    --   {
    --     "<leader>ff",
    --     function()
    --       Snacks.picker.files(customTelescope)
    --     end,
    --     desc = "Find Files",
    --   },
    --   {
    --     "<leader>fg",
    --     function()
    --       Snacks.picker.git_files(customTelescope)
    --     end,
    --     desc = "Find Git Files",
    --   },
    --   {
    --     "<leader>fp",
    --     function()
    --       Snacks.picker.projects(customTelescope)
    --     end,
    --     desc = "Projects",
    --   },
    --   {
    --     "<leader>fr",
    --     function()
    --       Snacks.picker.recent(customTelescope)
    --     end,
    --     desc = "Recent",
    --   },
    --
    --   {
    --     "<leader>gl",
    --     function()
    --       Snacks.picker.git_log(customTelescope)
    --     end,
    --     desc = "Git Log",
    --   },
    --   {
    --     "<leader>gL",
    --     function()
    --       Snacks.picker.git_log_line(customTelescope)
    --     end,
    --     desc = "Git Log Line",
    --   },
    --   {
    --     "<leader>gs",
    --     function()
    --       Snacks.picker.git_status(customTelescope)
    --     end,
    --     desc = "Git Status",
    --   },
    --   {
    --     "<leader>gS",
    --     function()
    --       Snacks.picker.git_stash(customTelescope)
    --     end,
    --     desc = "Git Stash",
    --   },
    --   {
    --     "<leader>gd",
    --     function()
    --       Snacks.picker.git_diff(customTelescope)
    --     end,
    --     desc = "Git Diff (Hunks)",
    --   },
    --   {
    --     "<leader>gf",
    --     function()
    --       Snacks.picker.git_log_file(customTelescope)
    --     end,
    --     desc = "Git Log File",
    --   },
    --
    --   -- gh
    --   {
    --     "<leader>gi",
    --     function()
    --       Snacks.picker.gh_issue(customTelescope)
    --     end,
    --     desc = "GitHub Issues (open)",
    --   },
    --   {
    --     "<leader>gI",
    --     function()
    --       Snacks.picker.gh_issue(vim.tbl_extend("force", { state = "all" }, customTelescope))
    --     end,
    --     desc = "GitHub Issues (all)",
    --   },
    --   {
    --     "<leader>gp",
    --     function()
    --       Snacks.picker.gh_pr(customTelescope)
    --     end,
    --     desc = "GitHub Pull Requests (open)",
    --   },
    --   {
    --     "<leader>gP",
    --     function()
    --       Snacks.picker.gh_pr(vim.tbl_extend("force", { state = "all" }, customTelescope))
    --     end,
    --     desc = "GitHub Pull Requests (all)",
    --   },
    --
    --   -- Grep
    --   {
    --     "<leader>sb",
    --     function()
    --       Snacks.picker.lines(customTelescope)
    --     end,
    --     desc = "Buffer Lines",
    --   },
    --   {
    --     "<leader>sB",
    --     function()
    --       Snacks.picker.grep_buffers(customTelescope)
    --     end,
    --     desc = "Grep Open Buffers",
    --   },
    --   {
    --     "<leader>sw",
    --     function()
    --       Snacks.picker.grep_word(customTelescope)
    --     end,
    --     desc = "Visual selection or word",
    --     mode = { "n", "x" },
    --   },
    --
    --   -- search
    --   {
    --     '<leader>s"',
    --     function()
    --       Snacks.picker.registers(customTelescope)
    --     end,
    --     desc = "Registers",
    --   },
    --   {
    --     "<leader>s/",
    --     function()
    --       Snacks.picker.search_history(customTelescope)
    --     end,
    --     desc = "Search History",
    --   },
    --   {
    --     "<leader>sa",
    --     function()
    --       Snacks.picker.autocmds(customTelescope)
    --     end,
    --     desc = "Autocmds",
    --   },
    --   {
    --     "<leader>sb",
    --     function()
    --       Snacks.picker.lines(customTelescope)
    --     end,
    --     desc = "Buffer Lines",
    --   },
    --   {
    --     "<leader>sc",
    --     function()
    --       Snacks.picker.command_history(customTelescope)
    --     end,
    --     desc = "Command History",
    --   },
    --   {
    --     "<leader>sC",
    --     function()
    --       Snacks.picker.commands(customTelescope)
    --     end,
    --     desc = "Commands",
    --   },
    --   {
    --     "<leader>sd",
    --     function()
    --       Snacks.picker.diagnostics(customTelescope)
    --     end,
    --     desc = "Diagnostics",
    --   },
    --   {
    --     "<leader>sD",
    --     function()
    --       Snacks.picker.diagnostics_buffer(customTelescope)
    --     end,
    --     desc = "Buffer Diagnostics",
    --   },
    --   {
    --     "<leader>sh",
    --     function()
    --       Snacks.picker.help(customTelescope)
    --     end,
    --     desc = "Help Pages",
    --   },
    --   {
    --     "<leader>sH",
    --     function()
    --       Snacks.picker.highlights(customTelescope)
    --     end,
    --     desc = "Highlights",
    --   },
    --   {
    --     "<leader>si",
    --     function()
    --       Snacks.picker.icons(customTelescope)
    --     end,
    --     desc = "Icons",
    --   },
    --   {
    --     "<leader>sj",
    --     function()
    --       Snacks.picker.jumps(customTelescope)
    --     end,
    --     desc = "Jumps",
    --   },
    --   {
    --     "<leader>sk",
    --     function()
    --       Snacks.picker.keymaps(customTelescope)
    --     end,
    --     desc = "Keymaps",
    --   },
    --   {
    --     "<leader>sl",
    --     function()
    --       Snacks.picker.loclist(customTelescope)
    --     end,
    --     desc = "Location List",
    --   },
    --   {
    --     "<leader>sm",
    --     function()
    --       Snacks.picker.marks(customTelescope)
    --     end,
    --     desc = "Marks",
    --   },
    --   {
    --     "<leader>sM",
    --     function()
    --       Snacks.picker.man(customTelescope)
    --     end,
    --     desc = "Man Pages",
    --   },
    --   {
    --     "<leader>sp",
    --     function()
    --       Snacks.picker.lazy(customTelescope)
    --     end,
    --     desc = "Search for Plugin Spec",
    --   },
    --   {
    --     "<leader>sq",
    --     function()
    --       Snacks.picker.qflist(customTelescope)
    --     end,
    --     desc = "Quickfix List",
    --   },
    --   {
    --     "<leader>sR",
    --     function()
    --       Snacks.picker.resume(customTelescope)
    --     end,
    --     desc = "Resume",
    --   },
    --   {
    --     "<leader>su",
    --     function()
    --       Snacks.picker.undo(customTelescope)
    --     end,
    --     desc = "Undo History",
    --   },
    --   {
    --     "<leader>uC",
    --     function()
    --       Snacks.picker.colorschemes(customTelescope)
    --     end,
    --     desc = "Colorschemes",
    --   },
    --
    --   -- LSP
    --   {
    --     "gd",
    --     function()
    --       Snacks.picker.lsp_definitions(customTelescope)
    --     end,
    --     desc = "Goto Definition",
    --   },
    --   {
    --     "gD",
    --     function()
    --       Snacks.picker.lsp_declarations(customTelescope)
    --     end,
    --     desc = "Goto Declaration",
    --   },
    --   {
    --     "gr",
    --     function()
    --       Snacks.picker.lsp_references(customTelescope)
    --     end,
    --     nowait = true,
    --     desc = "References",
    --   },
    --   {
    --     "gI",
    --     function()
    --       Snacks.picker.lsp_implementations(customTelescope)
    --     end,
    --     desc = "Goto Implementation",
    --   },
    --   {
    --     "gy",
    --     function()
    --       Snacks.picker.lsp_type_definitions(customTelescope)
    --     end,
    --     desc = "Goto Type Definition",
    --   },
    --   {
    --     "gai",
    --     function()
    --       Snacks.picker.lsp_incoming_calls(customTelescope)
    --     end,
    --     desc = "Calls Incoming",
    --   },
    --   {
    --     "gao",
    --     function()
    --       Snacks.picker.lsp_outgoing_calls(customTelescope)
    --     end,
    --     desc = "Calls Outgoing",
    --   },
    --   {
    --     "<leader>ss",
    --     function()
    --       Snacks.picker.lsp_symbols(customTelescope)
    --     end,
    --     desc = "LSP Symbols",
    --   },
    --   {
    --     "<leader>sS",
    --     function()
    --       Snacks.picker.lsp_workspace_symbols(customTelescope)
    --     end,
    --     desc = "LSP Workspace Symbols",
    --   },
    -- },
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
