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
        ["<C-d>"] = { "select_next" },
        ["<C-c>"] = { "select_prev" },
      },
      fuzzy = {
        max_typos = function(keyword)
          return math.floor(#keyword / 4)
        end,
        use_frecency = true,
        use_proximity = true,
        use_unsafe_no_lock = false,
        sorts = { "score", "exact", "sort_text" },
      },
      cmdline = { completion = { ghost_text = { enabled = false } } },
      signature = { trigger = { enabled = true, show_on_keyword = true, show_on_insert = true } },
    },
  },

  {
    "folke/ts-comments.nvim",
    opts = {
      langs = {
        dts = "// %s",
      },
    },
  },

  {
    "chrisgrieser/nvim-scissors",
    opts = { jsonFormatter = "jq" },
    keys = {
      {
        "<leader>cB",
        function()
          require("scissors").editSnippet()
        end,
        desc = "Edit Snippets",
      },
      {
        "<leader>cb",
        mode = { "n", "v" },
        function()
          require("scissors").addNewSnippet()
        end,
        desc = "Add Snippets",
      },
    },
  },

  { "mg979/vim-visual-multi" },

  { "echasnovski/mini.surround", version = false, opts = { n_lines = 100 } },

  {
    "echasnovski/mini.move",
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

  {
    "dmtrKovalenko/fff.nvim",
    build = "cargo build --release",
    opts = {
      debug = {
        show_scores = true, -- to help us optimize the scoring system, feel free to share your scores!
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
}
