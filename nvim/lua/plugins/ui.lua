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
    -- opts = { colorscheme = "catppuccin-macchiato" },
    opts = { colorscheme = "catppuccin-frappe" },
    -- opts = { colorscheme = "vscode" },
  },
  {
    "b0o/incline.nvim",
    config = function()
      require("incline").setup(require("incline").setup({
        window = {
          padding = 0,
          margin = { horizontal = 0 },
        },
        render = function(props)
          local helpers = require("incline.helpers")
          local devicons = require("nvim-web-devicons")
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if filename == "" then
            filename = "[No Name]"
          end
          local ft_icon, ft_color = devicons.get_icon_color(filename)
          local modified = vim.bo[props.buf].modified
          return {
            ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or "",
            " ",
            { filename, gui = modified and "bold,italic" or "bold" },
            " ",
            guibg = "#44406e",
          }
        end,
      }))
    end,
    event = "VeryLazy",
  },

  -- Installed Themes
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
      -- transparent_background = false,
    },
  },
  require("treesitter-context").setup({
    -- multiwindow = true, -- Enable multiwindow support.
    trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    mode = "topline", -- Line used to calculate context. Choices: 'cursor', 'topline'
  }),

  -- turn off inlay hint by default
  { "neovim/nvim-lspconfig", opts = { inlay_hints = { enabled = false } } },
}
