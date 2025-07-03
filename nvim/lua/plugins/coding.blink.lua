return {
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      keymap = {
        preset = "default",
        ["<C-g>"] = { "accept" },
        ["<C-d>"] = { "select_next" },
        ["<C-c>"] = { "select_prev" },
      },
      appearance = {
        nerd_font_variant = "normal",
        use_nvim_cmp_as_default = true,
      },
      completion = {

        documentation = {
          auto_show = true,
          auto_show_delay_ms = 100,
          treesitter_highlighting = true,
        },
        accept = {
          auto_brackets = { semantic_token_resolution = { blocked_filetypes = { "typescriptreact", "typescript" } } },
        },
      },
      sources = { default = { "lsp", "buffer", "path" } },
      fuzzy = {
        implementation = "rust",
        prebuilt_binaries = { ignore_version_mismatch = true },
      },

      cmdline = {
        keymap = {
          preset = "inherit",
          ["<Tab>"] = { "show", "accept", "fallback" },
        },
        completion = { menu = { auto_show = true }, ghost_text = { enabled = false } },
      },
      -- Experimental signature help support
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
    },
    opts_extend = { "sources.default" },
  },
  -- {
  --   "saghen/blink.cmp",
  --   ---@module 'blink.cmp'
  --   ---@type blink.cmp.Config
  --   opts = {
  --     completion = {
  --       -- accept = { auto_brackets = { enabled = true } },
  --       -- list = {
  --       --   selection = {
  --       --     auto_insert = false,
  --       --     preselect = true,
  --       --   },
  --       -- },
  --       documentation = {
  --         auto_show = true,
  --         -- auto_show_delay_ms = 100,
  --         treesitter_highlighting = true,
  --       },
  --       ghost_text = {
  --         enabled = true,
  --         show_without_selection = true,
  --       },
  --       menu = {
  --         scrollbar = true,
  --         auto_show = true,
  --         draw = {
  --           components = {
  --             kind_icon = {
  --               text = function(ctx)
  --                 local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
  --                 return kind_icon
  --               end,
  --               highlight = function(ctx)
  --                 local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
  --                 return hl
  --               end,
  --             },
  --             kind = {
  --               highlight = function(ctx)
  --                 local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
  --                 return hl
  --               end,
  --             },
  --           },
  --         },
  --       },
  --     },
  --     signature = {
  --       enabled = true,
  --       trigger = {
  --         enabled = true,
  --         show_on_keyword = false,
  --         show_on_insert = true,
  --         show_on_insert_on_trigger_character = true,
  --       },
  --     },
  --   },
  -- },
}
