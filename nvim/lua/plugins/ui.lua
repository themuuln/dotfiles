return {
  {
    "LazyVim/LazyVim",
    -- opts = { colorscheme = "tokyonight-night" },
    opts = { colorscheme = "kanagawa-wave" },
  },

  {
    "rebelot/kanagawa.nvim",
    opts = {
      compile = true,
      transparent = true,
    },
  },

  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        separator_style = "slope",
        indicator = {
          icon = "",
          style = "none",
        },
        show_buffer_close_icons = false,
        show_tab_indicators = false,
        hover = {
          enabled = false,
        },
      },
    },
  },
}
