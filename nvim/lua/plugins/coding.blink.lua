return {
  {
    "saghen/blink.cmp",
    dependencies = { "supermaven-nvim", "saghen/blink.compat" },
    opts = {
      cmdline = { enabled = false },
      signature = { enabled = true },
      completion = {
        keyword = { range = "full" },
        list = { selection = { preselect = true, auto_insert = true } },
        accept = { auto_brackets = { enabled = true } },
        menu = {
          auto_show = true,
          draw = {
            treesitter = { "lsp" },
            columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
          },
        },
        documentation = { auto_show = true, auto_show_delay_ms = 0 },
        ghost_text = { enabled = true },
      },
    },
  },
}
