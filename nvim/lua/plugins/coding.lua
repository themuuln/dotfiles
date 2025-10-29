return {

  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "enter",
        ["<C-g>"] = { "accept" },
      },
    },
  },

  {
    "dmtrKovalenko/fff.nvim",
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    opts = {
      debug = {
        enabled = false,
        show_scores = false,
      },
    },
    lazy = false,
    keys = {
      {
        "<leader><Space>",
        function()
          require("fff").find_files()
        end,
        desc = "FFFind files",
      },
    },
  },

  -- {
  --   "chrisgrieser/nvim-scissors",
  --   opts = { jsonFormatter = "jq" },
  --   keys = {
  --     {
  --       "<leader>cB",
  --       function()
  --         require("scissors").editSnippet()
  --       end,
  --       desc = "Edit Snippets",
  --     },
  --     {
  --       "<leader>cb",
  --       mode = { "n", "v" },
  --       function()
  --         require("scissors").addNewSnippet()
  --       end,
  --       desc = "Add Snippets",
  --     },
  --   },
  -- },

  { "mg979/vim-visual-multi" },

  { "nvim-mini/mini.surround", version = false, opts = { n_lines = 100 } },

  {
    "nvim-mini/mini.move",
    opts = {
      mappings = {
        left = "<A-Left>",
        right = "<A-Right>",
        down = "J",
        up = "K",

        line_left = "<A-Left>",
        line_right = "<A-Right>",
        line_down = "<A-Down>",
        line_up = "<A-Up>",
      },
    },
  },
}
