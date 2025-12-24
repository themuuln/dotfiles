return {
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "kanagawa" },
  },

  -- Main theme
  { "rebelot/kanagawa.nvim", priority = 1000, opts = { transparent = false, compile = true } },


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

  {
    "AlexvZyl/nordic.nvim",
    lazy = true,
  },

  {
    "navarasu/onedark.nvim",
    lazy = true,
    config = function()
      require("onedark").setup({
        style = "darker",
      })
    end,
  },

  {
    "akinsho/bufferline.nvim",
    enabled = true,
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
          enabled = true,
          reveal = { "close" },
        },
        diagnostics = "nvim_lsp",
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "left",
            separator = true,
          },
        },
      },
      highlights = {
        fill = {
          bg = { attribute = "bg", highlight = "Normal" },
        },
        background = {
          bg = { attribute = "bg", highlight = "Normal" },
        },
        buffer_selected = {
          bg = { attribute = "bg", highlight = "Normal" },
          fg = { attribute = "fg", highlight = "Normal" },
        },
      },
    },
  },
}
