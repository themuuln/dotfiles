vim.fn.sign_define("DiagnosticSignError", { texthl = "DiagnosticSignError", text = "" })
vim.fn.sign_define("DiagnosticSignWarn", { texthl = "DiagnosticSignWarn", text = "" })
vim.fn.sign_define("DiagnosticSignHint", { texthl = "DiagnosticSignHint", text = "" })
vim.fn.sign_define("DiagnosticSignInfo", { texthl = "DiagnosticSignInfo", text = "" })

return {
  -- { "ahkinsho/git-conflict.nvim", version = "*", config = true },

  {
    "mistweaverco/kulala.nvim",
    opts = {
      -- possible values: b = buffer, g = global
      environment_scope = "b",
      default_env = "dev",
      vscode_rest_client_environmentvars = false,

      ui = {
        max_response_size = 128 * 1024,
        win_opts = {},
        -- default view: "body" or "headers" or "headers_body" or "verbose" or fun(response: Response)
        default_view = "body",
        -- enable winbar
        winbar = true,
        default_winbar_panes = { "body" },
        -- possible values: false, "float"
        -- show_variable_info_text = false,
        show_variable_info_text = "float",
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
    "wakatime/vim-wakatime",
    event = "VeryLazy",
    setup = function()
      vim.cmd([[packadd wakatime/vim-wakatime]])
    end,
  },

  { "DavidAnson/markdownlint", enabled = false },

  -- {
  --   "harrisoncramer/gitlab.nvim",
  --   build = function()
  --     require("gitlab.server").build(true)
  --   end, -- Builds the Go binary
  --   config = function()
  --     require("gitlab").setup({
  --       auth_provider = function()
  --         return os.getenv("GITLAB_TOKEN"), os.getenv("GITLAB_VIM_URL"), nil
  --       end,
  --     })
  --   end,
  -- },

  {
    "NeogitOrg/neogit",
    enabled = true,
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
    },
  },

  {
    "saxon1964/neovim-tips",
    version = "*", -- Only update on tagged releases
    dependencies = {
      "MunifTanjim/nui.nvim",
      "MeanderingProgrammer/render-markdown.nvim",
    },
    opts = {
      -- OPTIONAL: Location of user defined tips (default value shown below)
      user_file = vim.fn.stdpath("config") .. "/neovim_tips/user_tips.md",
      -- OPTIONAL: Prefix for user tips to avoid conflicts (default: "[User] ")
      user_tip_prefix = "[User] ",
      -- OPTIONAL: Show warnings when user tips conflict with builtin (default: true)
      warn_on_conflicts = true,
      -- OPTIONAL: Daily tip mode (default: 1)
      -- 0 = off, 1 = once per day, 2 = every startup
      daily_tip = 1,
    },
    init = function()
      -- OPTIONAL: Change to your liking or drop completely
      -- The plugin does not provide default key mappings, only commands
      local map = vim.keymap.set
      map("n", "<leader>nto", ":NeovimTips<CR>", { desc = "Neovim tips", noremap = true, silent = true })
      map("n", "<leader>nte", ":NeovimTipsEdit<CR>", { desc = "Edit your Neovim tips", noremap = true, silent = true })
      map("n", "<leader>nta", ":NeovimTipsAdd<CR>", { desc = "Add your Neovim tip", noremap = true, silent = true })
      map("n", "<leader>nth", ":help neovim-tips<CR>", { desc = "Neovim tips help", noremap = true, silent = true })
      map("n", "<leader>ntr", ":NeovimTipsRandom<CR>", { desc = "Show random tip", noremap = true, silent = true })
      map("n", "<leader>ntp", ":NeovimTipsPdf<CR>", { desc = "Open Neovim tips PDF", noremap = true, silent = true })
    end,
  },
  {
    "obsidian-nvim/obsidian.nvim",
    lazy = true,
    ft = "markdown",
    cmd = { "ObsidianSearch", "ObsidianQuickSwitch", "ObsidianNew" },
    version = "*",
    opts = {
      homepage = "/Users/ict/Library/Mobile Documents/iCloud~md~obsidian/Documents/main",
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
    },
  },

  {
    "aznhe21/actions-preview.nvim",

    -- Run this AFTER the plugin is loaded, so require() works.
    opts = function()
      local highlight_command = {}
      local ok, hl = pcall(require, "actions-preview.highlight")
      if ok then
        table.insert(highlight_command, hl.delta())
      -- you can add others later:
      -- table.insert(highlight_command, hl.diff_so_fancy())
      -- table.insert(highlight_command, hl.diff_highlight())
      else
        -- Optional: fall back silently if highlight module isn’t available
        -- (e.g. snapshot mismatch). You still get a working plugin.
      end

      return {
        diff = { ctxlen = 3 },
        highlight_command = highlight_command,
        backend = { "snacks" },

        -- nui = { ... }
        -- snacks = { layout = { preset = "default" } },
      }
    end,

    keys = {
      {
        "gf",
        function()
          require("actions-preview").code_actions()
        end,
        mode = { "n", "v" },
        desc = "Code Action (actions-preview)",
      },
    },
  },

  -- PERF: temporarily disabled
  -- require("treesitter-context").setup({
  --   multiwindow = true,
  --   trim_scope = "outer",
  --   mode = "topline",
  -- }),
}
