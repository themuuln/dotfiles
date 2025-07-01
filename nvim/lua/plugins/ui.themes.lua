return {
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin" },
  },
  { "catppuccin/nvim", name = "catppuccin" },
  { "AlexvZyl/nordic.nvim", name = "nordic" },
  -- recolor devicons to match theme
  {
    "rachartier/tiny-devicons-auto-colors.nvim",
    event = "UIEnter",
    dependencies = {
      { "nvim-tree/nvim-web-devicons", commit = "9154484705968658e9aab2b894d1b2a64bf9f83d" },
    },
    config = true,
  },

  -- main theme
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
  },
  -- {
  --   "nickkadutskyi/jb.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {},
  --   config = function()
  --     -- require("jb").setup({ transparent = true })
  --     vim.cmd("colorscheme jb")
  --   end,
  -- },
}
