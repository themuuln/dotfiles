return {
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
  },
  {
    "nvim-neorg/neorg",
    version = "*",
    ft = "norg",
    config = function()
      require("neorg").setup({
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {},
          ["core.completion"] = {},
          ["core.export"] = {},
          ["core.export.markdown"] = { extension = "md" },
          ["core.dirman"] = {
            config = {
              workspaces = {
                notes = "~/neorg/notes",
                work = "~/neorg/work",
              },
            },
          },
          ["core.journal"] = {
            config = {
              strategy = "nested",
              location = "~/neorg/journal",
              date_style = "+YYYY-%m-%d",
            },
          },
        },
      })
    end,
  },
}
