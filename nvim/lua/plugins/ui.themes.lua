return {
  {
    "LazyVim/LazyVim",
    -- opts = { colorscheme = "catppuccin" },
    -- opts = { colorscheme = "catppuccin-mocha" },
    -- opts = { colorscheme = "catppuccin-macchiato" },
    -- opts = { colorscheme = "github_dark_default" },
    -- opts = { colorscheme = "tokyonight" },
    -- opts = { colorscheme = "kanagawa-paper-ink" },
    -- opts = { colorscheme = "nordic" },
    -- opts = { colorscheme = "edge" },
    -- opts = { colorscheme = "onedark" },
    opts = { colorscheme = "tokyonight-moon" },
    -- opts = { colorscheme = "tokyonight-night" },
    -- opts = { colorscheme = "solarized-osaka" },
  },
  {
    "folke/tokyonight.nvim",
    -- opts = {
    --   transparent = true,
    -- },
  },
  { "catppuccin/nvim", name = "catppuccin" },
  {
    "AlexvZyl/nordic.nvim",
    name = "nordic",
    opts = {
      -- transparent = {
      --   -- Enable transparent background.
      --   bg = true,
      --   -- Enable transparent background for floating windows.
      --   float = true,
      -- },
    },
  },
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
  { "rebelot/kanagawa.nvim" },
  -- { "oxfist/night-owl.nvim" },
  -- { "ramojus/mellifluous.nvim" },
  -- { "rafamadriz/neon" },
  -- { "kvrohit/mellow.nvim" },
  -- { "Everblush/everblush.nvim" },
  -- { "cryptomilk/nightcity.nvim" },
  { "navarasu/onedark.nvim" },
  -- { "sainnhe/gruvbox-material" },
  -- { "projekt0n/github-nvim-theme" },
  -- { "sainnhe/everforest" },
  -- { "Mofiqul/vscode.nvim" },
  { "olimorris/onedarkpro.nvim" },
  { "craftzdog/solarized-osaka.nvim" },
  -- { "shaunsingh/nord.nvim" },
  { "tiagovla/tokyodark.nvim" },
  { "sainnhe/edge" },
  { "rmehri01/onenord.nvim" },
  -- { "bluz71/vim-nightfly-colors" },
  -- { "eldritch-theme/eldritch.nvim" },
  -- { "mcchrish/zenbones.nvim" },
  -- { "olivercederborg/poimandres.nvim" },
  -- { "mhartington/oceanic-next" },
  -- { "dgox16/oldworld.nvim" },
  { "sho-87/kanagawa-paper.nvim" },
  { "HoNamDuong/hybrid.nvim" },
  -- { "rockyzhang24/arctic.nvim" },
  -- { "Yazeed1s/oh-lucy.nvim" },
  -- { "datsfilipe/vesper.nvim" },
  -- { "kvrohit/substrata.nvim" },
  -- { "rktjmp/lush.nvim" },
}
