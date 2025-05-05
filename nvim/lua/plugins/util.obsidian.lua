return {
  {
    "obsidian-nvim/obsidian.nvim",
    lazy = true,
    ft = "markdown",
    cmd = { "ObsidianSearch", "ObsidianQuickSwitch", "ObsidianNew" },
    version = "*",
    opts = {
      workspaces = {
        {
          name = "main",
          path = "/Users/ict/Library/Mobile Documents/iCloud~md~obsidian/Documents/main",
        },
        {
          name = "work",
          path = "~/vaults/work",
        },
      },

      completion = {
        nvim_cmp = false, -- NOTE: use blink.cmp instead
        blink = true,
        min_chars = 2,
      },

      picker = {
        name = "snacks.pick",
      },

      templates = {
        folder = "05 - Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        substitutions = {},
      },
    },
  },
  { "DavidAnson/markdownlint", enabled = false },
}
