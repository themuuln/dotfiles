return {
  -- set default theme here
  {
    "LazyVim/LazyVim",
    -- opts = { colorscheme = "github_dark_dimmed" },
    opts = { colorscheme = "nordic" },
    -- opts = { colorscheme = "kanagawa-wave" },
    -- opts = { colorscheme = "catppuccin-macchiato" },
    -- opts = { colorscheme = "catppuccin-frappe" },
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
  { "folke/tokyonight.nvim", opts = { transparent = true } },
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
  { "Mofiqul/vscode.nvim", opts = {
    transparent = true,
  } },
  { "oxfist/night-owl.nvim" },
  { "ramojus/mellifluous.nvim" },
  { "atmosuwiryo/vim-winteriscoming" },
  { "rmehri01/onenord.nvim" },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, 2, LazyVim.lualine.cmp_source("supermaven"))
    end,
  },
}
