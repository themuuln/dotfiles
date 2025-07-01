return {
  -- {
  --   "rmagatti/auto-session",
  --   lazy = false,
  --   ---@module "auto-session"
  --   ---@type AutoSession.Config
  --   opts = {
  --     suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
  --   },
  -- },

  {
    "rmagatti/goto-preview",
    dependencies = { "rmagatti/logger.nvim" },
    event = "BufEnter",
    config = true,
    opts = {
      default_mappings = true,
    },
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  { "jake-stewart/force-cul.nvim", opts = {} },

  {
    "chrisgrieser/nvim-spider",
    keys = {
      {
        "w",
        function()
          require("spider").motion("w")
        end,
        mode = { "n", "o", "x" },
      },
      {
        "e",
        function()
          require("spider").motion("e")
        end,
        mode = { "n", "o", "x" },
      },
      {
        "b",
        function()
          require("spider").motion("b")
        end,
        mode = { "n", "o", "x" },
      },
    },
    opts = { subwordMovement = true },
  },

  -- partition UI elements
  {
    enabled = false,
    "folke/edgy.nvim",
    event = "VeryLazy",
    opts = {
      animate = { enabled = false },
      icons = {
        closed = "",
        open = "",
      },
      wo = { winbar = false },
      options = {
        left = { size = 40 },
        right = { size = 80 },
      },
      bottom = {
        "trouble",
        { ft = "qf", title = "QuickFix" },
      },
      left = { { ft = "blink-tree" } },
      right = {
        {
          ft = "toggleterm",
          -- exclude floating windows
          filter = function(_, win)
            return vim.api.nvim_win_get_config(win).relative == ""
          end,
        },
      },
    },
  },

  -- LSP notifications
  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    opts = {
      notification = { window = { normal_hl = "Normal" } },
      integration = {
        ["nvim-tree"] = { enable = false },
        ["xcodebuild-nvim"] = { enable = false },
      },
    },
  },
}
