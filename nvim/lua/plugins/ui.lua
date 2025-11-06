return {
  {
    "LazyVim/LazyVim",
    -- opts = { colorscheme = "tokyonight-night" },
    -- opts = { colorscheme = "tokyonight-moon" },
    -- opts = { colorscheme = "catppuccin-macchiato" },
    -- opts = { colorscheme = "catppuccin-mocha" },
    -- opts = { colorscheme = "github_dark_dimmed" },
    -- opts = { colorscheme = "kanagawa-dragon" },
    -- opts = { colorscheme = "kanagawa-paper-ink" },
    -- opts = { colorscheme = "nordic" },
    -- opts = { colorscheme = "nord" },
    -- opts = { colorscheme = "hybrid" },
    -- opts = { colorscheme = "vague" },
    -- opts = { colorscheme = "rose-pine-main" },
    -- opts = { colorscheme = "onedark", },
  },

  -- {
  --   "folke/tokyonight.nvim",
  --   opts = {
  --     transparent = true,
  --     styles = {
  --       -- Style to be applied to different syntax groups
  --       -- Value is any valid attr-list value for `:help nvim_set_hl`
  --       comments = { italic = true },
  --       keywords = { italic = false },
  --       functions = {},
  --       variables = {},
  --       -- Background styles. Can be "dark", "transparent" or "normal"
  --       sidebars = "transparent", -- style for sidebars, see below
  --       floats = "transparent", -- style for floating windows
  --     },
  --   },
  -- },

  -- {
  --   "vague-theme/vague.nvim",
  --   -- lazy = false,
  --   -- priority = 1000,
  -- },

  -- {
  --   "rose-pine/neovim",
  --   name = "rose-pine",
  -- },

  { "catppuccin/nvim", name = "catppuccin", opts = { transparent_background = false } },

  {
    "thesimonho/kanagawa-paper.nvim",
    lazy = true,
    opts = function()
      return {
        transparent = true,
        diag_background = false,
      }
    end,
  },

  -- main theme
  { "rebelot/kanagawa.nvim", opts = { transparent = true, compile = true } },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      tabline = {
        lualine_a = {
          {
            "buffers",
            symbols = { alternate_file = "" },
            hide_filename_extension = true,
            use_mode_colors = true,
          },
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "tabs" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  {
    "akinsho/bufferline.nvim",
    enabled = false,
    opts = {
      options = {
        indicator = {
          icon = "",
          style = "none",
        },
        show_buffer_close_icons = false,
        show_tab_indicators = false,
      },
    },
  },
}
