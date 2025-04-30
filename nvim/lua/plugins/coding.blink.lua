return {
  {
    "saghen/blink.cmp",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      completion = {
        list = {
          selection = {
            auto_insert = true,
            preselect = true,
          },
        },
        accept = {},
        documentation = { auto_show = false, treesitter_highlighting = false },
        ghost_text = { enabled = vim.g.ai_cmp },
        menu = {
          auto_show = true,
          draw = {
            components = {
              kind_icon = {
                text = function(ctx)
                  local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  return kind_icon
                end,
                -- (optional) use highlights from mini.icons
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
              kind = {
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
            },
          },
        },
      },
      signature = {
        enabled = true,
        trigger = {
          enabled = true,
          show_on_keyword = true,
          show_on_insert = true,
          show_on_insert_on_trigger_character = true,
        },
        window = {
          treesitter_highlighting = true,
          show_documentation = true,
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
