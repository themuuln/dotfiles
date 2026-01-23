return {
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "tokyonight-night" },
  },

  { "rebelot/kanagawa.nvim" },

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
