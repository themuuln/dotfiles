return {
  {
    "LazyVim/LazyVim",
    -- opts = { colorscheme = "github_dark_dimmed" },
    -- opts = { colorscheme = "nordic" },
    -- opts = { colorscheme = "everforest" },
    -- opts = { colorscheme = "zenbones" },
    -- opts = { colorscheme = "tokyonight" },
    -- opts = { colorscheme = "kanagawa-wave" },
    -- opts = { colorscheme = "solarized-osaka" },
    opts = { colorscheme = "catppuccin-macchiato" },
    -- opts = { colorscheme = "catppuccin-frappe" },
    -- opts = { colorscheme = "vscode" },
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      -- transparent = true,
      transparent = false,
    },
  },
  { "AlexvZyl/nordic.nvim", opts = { transparent = { bg = true, float = true } } },
  {
    "navarasu/onedark.nvim",
    opts = {
      transparent = true,
      toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" },
      code_style = { keywords = "italic" },
      lualine = { transparent = false },
    },
  },
  { "craftzdog/solarized-osaka.nvim" },
  { "rebelot/kanagawa.nvim" },
  { "projekt0n/github-nvim-theme" },
  { "rose-pine/neovim" },
  {
    "Mofiqul/vscode.nvim",
    opts = {
      transparent = false,
      -- transparent = true,
    },
  },
  { "oxfist/night-owl.nvim" },
  { "ramojus/mellifluous.nvim" },
  { "atmosuwiryo/vim-winteriscoming" },
  { "rmehri01/onenord.nvim" },
  { "sainnhe/everforest" },
  {
    "zenbones-theme/zenbones.nvim",
    dependencies = "rktjmp/lush.nvim",
  },
  { "olivercederborg/poimandres.nvim" },
  { "ramojus/mellifluous.nvim" },
  { "ayu-theme/ayu-vim" },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      transparent_background = true,
    },
  },
}
