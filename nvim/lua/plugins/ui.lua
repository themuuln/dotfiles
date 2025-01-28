return {
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = { plugins = { gitsigns = true, tmux = true, kitty = { enabled = false, font = "+2" } } },
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
  },
  {
    "folke/tokyonight.nvim",
    opts = { transparent = true, styles = { sidebars = "transparent", floats = "transparent" } },
  },
  {
    "b0o/incline.nvim",
    event = "BufReadPre",
    priority = 1200,
    config = function()
      require("incline").setup({
        window = { margin = { vertical = 0, horizontal = 1 } },
        hide = {
          cursorline = true,
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if vim.bo[props.buf].modified then
            filename = "[+] " .. filename
          end

          local icon, color = require("nvim-web-devicons").get_icon_color(filename)
          return { { icon, guifg = color }, { " " }, { filename } }
        end,
      })
    end,
  },
  -- colorschemes
  -- { "olimorris/onedarkpro.nvim" },
  -- { "AlexvZyl/nordic.nvim" },
  -- { "sainnhe/everforest" },
  -- { "navarasu/onedark.nvim" },
  -- { "craftzdog/solarized-osaka.nvim" },
}
