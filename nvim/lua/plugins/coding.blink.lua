return {
  {
    "saghen/blink.cmp",
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
      signature = {
        enabled = true,
        trigger = {
          enabled = true,
          show_on_keyword = false,
          show_on_insert = true,
          show_on_insert_on_trigger_character = true,
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
