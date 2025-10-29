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
        -- show_variable_info_text = "float",
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

  -- screenshot
  {
    "mistricky/codesnap.nvim",
    build = "make",
    opts = {
      mac_window_bar = false,
      title = "",
      code_font_family = "JetBrainsMono Nerd Font Mono",
      watermark_font_family = "",
      watermark = "",
      bg_theme = "default",
      breadcrumbs_separator = "/",
      has_breadcrumbs = true,
      has_line_number = true,
      show_workspace = true,
      min_width = 0,
      bg_x_padding = 0,
      bg_y_padding = 0,
      save_path = os.getenv("XDG_PICTURES_DIR") or (os.getenv("HOME") .. "/Pictures"),
    },
  },

  {
    "nvzone/typr",
    dependencies = "nvzone/volt",
    opts = {},
    cmd = { "Typr", "TyprStats" },
  },
  require("treesitter-context").setup({
    multiwindow = true,
    trim_scope = "outer",
    mode = "topline",
  }),
}
