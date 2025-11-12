return {
  {
    "LazyVim/LazyVim",
    -- opts = { colorscheme = "tokyonight-night" },
    -- opts = { colorscheme = "catppuccin" },
    -- opts = { colorscheme = "kanagawa-dragon" },
  },

  -- {
  --   "rose-pine/neovim",
  --   name = "rose-pine",
  -- },

  -- { "catppuccin/nvim", name = "catppuccin", opts = { transparent_background = false } },

  -- {
  --   "thesimonho/kanagawa-paper.nvim",
  --   lazy = true,
  --   opts = function()
  --     return {
  --       transparent = true,
  --       diag_background = false,
  --     }
  --   end,
  -- },

  -- main theme
  { "rebelot/kanagawa.nvim", opts = { transparent = false, compile = true } },

  {
    "nvim-lualine/lualine.nvim",
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
