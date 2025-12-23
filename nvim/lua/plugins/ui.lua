return {
  {
    "LazyVim/LazyVim",
    -- opts = { colorscheme = "tokyonight-night" },
    -- opts = { colorscheme = "catppuccin" },
    -- opts = { colorscheme = "kanagawa-dragon" },
    -- opts = { colorscheme = "onedark" },
    -- opts = { colorscheme = "vague" },
    -- opts = { colorscheme = "nordic" },
  },

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
  { "rebelot/kanagawa.nvim", opts = { transparent = false, compile = true } },

  { "shaunsingh/nord.nvim" },

  {
    "AlexvZyl/nordic.nvim",
    lazy = true,
    -- priority = 1000,
  },

  {
    "navarasu/onedark.nvim",
    config = function()
      require("onedark").setup({
        style = "darker",
        -- style = "warmer",
      })
      -- require("onedark").load()
    end,
  },

  { "rmehri01/onenord.nvim" },

  {
    "nickkadutskyi/jb.nvim",
    lazy = true,
  },

  { "Mofiqul/vscode.nvim" },

  { "nyoom-engineering/oxocarbon.nvim" },

  {
    "vague-theme/vague.nvim",
    lazy = true,
  },

  { "marko-cerovac/material.nvim" },

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
      },
    },
  },
}
