return {

  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "1.*",
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
        sorts = {
          "score",
          "exact",
          "sort_text",
        },
      },
      cmdline = {
        completion = {
          ghost_text = { enabled = false },
        },
      },
      signature = {
        enabled = true,
        trigger = {
          -- Show the signature help automatically
          enabled = true,
          -- Show the signature help window after typing any of alphanumerics, `-` or `_`
          show_on_keyword = true,
          blocked_trigger_characters = {},
          blocked_retrigger_characters = {},
          -- Show the signature help window after typing a trigger character
          show_on_trigger_character = true,
          -- Show the signature help window when entering insert mode
          show_on_insert = true,
          -- Show the signature help window when the cursor comes after a trigger character when entering insert mode
          show_on_insert_on_trigger_character = true,
        },
        window = {
          min_width = 1,
          max_width = 100,
          max_height = 10,
          border = nil, -- Defaults to `vim.o.winborder` on nvim 0.11+ or 'padded' when not defined/<=0.10
          winblend = 0,
          winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
          scrollbar = false, -- Note that the gutter will be disabled when border ~= 'none'
          -- Which directions to show the window,
          -- falling back to the next direction when there's not enough space,
          -- or another window is in the way
          direction_priority = { "n", "s" },
          -- Can accept a function if you need more control
          -- direction_priority = function()
          --   if condition then return { 'n', 's' } end
          --   return { 's', 'n' }
          -- end,

          -- Disable if you run into performance issues
          treesitter_highlighting = true,
          show_documentation = true,
        },
      },
      completion = {
        trigger = {
          prefetch_on_insert = true,
          show_in_snippet = true,
          show_on_backspace = true,
          show_on_backspace_in_keyword = true,
          show_on_backspace_after_accept = true,
          show_on_backspace_after_insert_enter = true,
          show_on_keyword = true,
          show_on_trigger_character = true,
          show_on_insert = true,
          show_on_blocked_trigger_characters = { " ", "\n", "\t" },
          show_on_accept_on_trigger_character = true,
          show_on_insert_on_trigger_character = true,
          show_on_x_blocked_trigger_characters = { "'", '"', "(" },
        },
        list = {
          max_items = 50,
          selection = {
            preselect = true,
            auto_insert = true,
          },
          cycle = {
            -- When `true`, calling `select_next` at the _bottom_ of the completion list
            -- will select the _first_ completion item.
            from_bottom = true,
            -- When `true`, calling `select_prev` at the _top_ of the completion list
            -- will select the _last_ completion item.
            from_top = true,
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 100,
          treesitter_highlighting = true,
        },
        accept = {
          dot_repeat = true,
          create_undo_point = true,
          resolve_timeout_ms = 100,
          -- auto_brackets = {
          --   enabled = true,
          --   default_brackets = { "(", ")" },
          --   override_brackets_for_filetypes = {},
          --   kind_resolution = {
          --     enabled = true,
          --     blocked_filetypes = { "typescriptreact", "javascriptreact", "vue" },
          --   },
          --   semantic_token_resolution = {
          --     enabled = true,
          --     blocked_filetypes = { "java" },
          --     timeout_ms = 400,
          --   },
          -- },
        },
        ghost_text = {
          enabled = true,
          show_with_selection = true,
          show_without_selection = false,
          show_with_menu = true,
          show_without_menu = false,
        },
      },
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
}
