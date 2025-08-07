vim.fn.sign_define("DiagnosticSignError", { texthl = "DiagnosticSignError", text = "" })
vim.fn.sign_define("DiagnosticSignWarn", { texthl = "DiagnosticSignWarn", text = "" })
vim.fn.sign_define("DiagnosticSignHint", { texthl = "DiagnosticSignHint", text = "" })
vim.fn.sign_define("DiagnosticSignInfo", { texthl = "DiagnosticSignInfo", text = "" })

return {
  { "lewis6991/foldsigns.nvim" },
  { "akinsho/git-conflict.nvim", version = "*", config = true },
  {
    "mistweaverco/kulala.nvim",
    opts = {
      -- possible values: b = buffer, g = global
      environment_scope = "b",
      default_env = "dev",
      vscode_rest_client_environmentvars = false,

      ui = {
        win_opts = {},
        -- default view: "body" or "headers" or "headers_body" or "verbose" or fun(response: Response)
        default_view = "body",
        -- enable winbar
        winbar = true,
        default_winbar_panes = { "body" },
        -- possible values: false, "float"
        show_variable_info_text = false,
        -- icons position: "signcolumn"|"on_request"|"above_request"|"below_request" or nil to disable
        show_icons = "signcolumn",
        icons = {
          inlay = {
            loading = "",
            done = "",
            error = "",
          },
        },
      },

      debug = 0,
    },
  },

  {
    "rmagatti/goto-preview",
    dependencies = { "rmagatti/logger.nvim" },
    event = "BufEnter",
    config = true,
    opts = {
      default_mappings = true,
    },
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- LSP notifications
  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    opts = {
      notification = { window = { normal_hl = "Normal" } },
      integration = {
        ["nvim-tree"] = { enable = false },
        ["xcodebuild-nvim"] = { enable = false },
      },
    },
  },

  {
    "shahshlok/vim-coach.nvim",
    dependencies = {
      "folke/snacks.nvim",
    },
    config = function()
      require("vim-coach").setup()
    end,
    keys = {
      { "<leader>?", "<cmd>VimCoach<cr>", desc = "Vim Coach" },
    },
  },

  {
    "wakatime/vim-wakatime",
    event = "VeryLazy",
    setup = function()
      vim.cmd([[packadd wakatime/vim-wakatime]])
    end,
  },

  {
    "folke/trouble.nvim",
    dependencies = { "rachartier/tiny-devicons-auto-colors.nvim" },
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics open<cr>",
        desc = "Diagnostics",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics open filter.buf=0<cr>",
        desc = "Buffer Diagnostics",
      },
      {
        "<leader>xs",
        "<cmd>Trouble symbols open focus=false<cr>",
        desc = "Symbols",
      },
      {
        "<leader>xl",
        "<cmd>Trouble lsp open focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ...",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist open<cr>",
        desc = "Location List",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist open<cr>",
        desc = "Quickfix List",
      },
    },
    --- @module 'trouble'
    --- @type trouble.Config
    opts = {
      focus = true,
      throttle = {
        preview = { debounce = false },
      },
      action_keys = {
        previous = { "k", "<Up>" },
        next = { "j", "<Down>" },
      },
    },
  },

  {
    "obsidian-nvim/obsidian.nvim",
    lazy = true,
    ft = "markdown",
    cmd = { "ObsidianSearch", "ObsidianQuickSwitch", "ObsidianNew" },
    version = "*",
    opts = {
      homepage = "/Users/ict/Library/Mobile Documents/iCloud~md~obsidian/Documents/main/Second Brain",
      workspaces = {
        {
          name = "main",
          path = "/Users/ict/Library/Mobile Documents/iCloud~md~obsidian/Documents/main",
        },
        {
          name = "work",
          path = "/Users/ict/Library/Mobile Documents/iCloud~md~obsidian/Documents/main/Second Brain/Work/ICT",
        },
      },
      completion = {
        nvim_cmp = false, -- NOTE: use blink.cmp instead
        blink = true,
        min_chars = 2,
      },
      picker = {
        name = "snacks.pick",
      },
      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        substitutions = {},
      },
    },
  },

  { "DavidAnson/markdownlint", enabled = false },

  {
    "gennaro-tedesco/nvim-jqx",
    event = { "BufReadPost" },
    ft = { "json", "yaml" },
  },

  {
    "Owen-Dechow/nvim_json_graph_view",
    dependencies = {
      "Owen-Dechow/graph_view_yaml_parser",
    },
    opts = {
      round_units = false,
    },
  },

  {
    "folke/which-key.nvim",
    enabled = true,
    opts = {
      layout = {
        width = { min = 10 }, -- min and max width of the columns
        spacing = 2, -- spacing between columns
      },
      preset = "helix",
      -- preset = "modern",
      -- preset = "classic",
      win = {},
      spec = {},
    },
  },

  require("treesitter-context").setup({
    multiwindow = true,
    trim_scope = "outer",
    mode = "topline",
  }),

  {
    "dinhhuy258/git.nvim",
    event = "BufReadPre",
  },

  {
    "harrisoncramer/gitlab.nvim",
    build = function()
      require("gitlab.server").build(true)
    end, -- Builds the Go binary
    config = function()
      require("gitlab").setup({
        auth_provider = function()
          return os.getenv("GITLAB_TOKEN"), os.getenv("GITLAB_VIM_URL"), nil
        end,
      })
    end,
  },

  { "sindrets/diffview.nvim" },
  { "tpope/vim-fugitive" },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      statuscolumn = { folds = { open = false } },
      notifier = { sort = { "added" } },
      scroll = {
        -- enabled = false,
        -- animate = {
        --   duration = { step = 10, total = 150 },
        -- },
      },
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
        win = {
          list = {
            keys = {
              ["<c-i>"] = { "toggle_input", mode = { "n", "i" } },
            },
          },
          input = {
            keys = {
              ["<c-l>"] = { "toggle_lua", mode = { "n", "i" } },
              ["<c-i>"] = { "toggle_input", mode = { "n", "i" } },
              -- ["<c-t>"] = { "edit_tab", mode = { "n", "i" } },
              -- ["<c-t>"] = { "yankit", mode = { "n", "i" } },
              -- ["<Esc>"] = { "close", mode = { "n", "i" } },
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
        -- enabled = false,
        chunk = { enabled = true },
      },
      animate = {
        fps = 120,
        easing = "inOutCubic",
      },
      -- dashboard = { example = "github" },
      dashboard = {
        sections = {
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          {
            pane = 2,
            icon = " ",
            desc = "Browse Repo",
            padding = 1,
            key = "b",
            action = function()
              Snacks.gitbrowse()
            end,
          },
          function()
            local in_git = Snacks.git.get_root() ~= nil
            local cmds = {
              {
                icon = " ",
                title = "Git Status",
                cmd = "git --no-pager diff --stat -B -M -C",
                pane = 2,
              },
            }
            return vim.tbl_map(function(cmd)
              return vim.tbl_extend("force", {
                section = "terminal",
                enabled = in_git,
                padding = 1,
                ttl = 5 * 60,
                indent = 3,
              }, cmd)
            end, cmds)
          end,
        },
      },
    },
  },

  {
    "akinsho/bufferline.nvim",
    enabled = false,
    -- opts = { options = { separator_style = "slope" } },
  },
}
