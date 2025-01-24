return {
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = { plugins = { gitsigns = true, tmux = true, kitty = { enabled = false, font = "+2" } } },
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
  },
  -- colorschemes
  -- { "olimorris/onedarkpro.nvim" },
  -- { "AlexvZyl/nordic.nvim" },
  -- { "sainnhe/everforest" },
  -- { "navarasu/onedark.nvim" },
  -- { "craftzdog/solarized-osaka.nvim" },
}
