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
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        sections = {
          { section = "keys", gap = 1, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          { section = "startup" },
        },
      },
    },
  },
}
