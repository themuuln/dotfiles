return {
  { "folke/tokyonight.nvim", opts = { transparent = true } },
  { "olimorris/onedarkpro.nvim" },
  { "AlexvZyl/nordic.nvim", opts = { transparent = { bg = true, float = true } } },
  { "sainnhe/everforest" },
  { "navarasu/onedark.nvim" },
  { "craftzdog/solarized-osaka.nvim" },
  { "rebelot/kanagawa.nvim" },
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false,
    priority = 1000,
    config = function()
      require("github-theme").setup({ options = { transparent = true } })
      vim.cmd("colorscheme github_dark_dimmed")
    end,
  },
}
