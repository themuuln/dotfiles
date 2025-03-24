return {
  -- for http requests postman, insomnia alternative
  {
    "mistweaverco/kulala.nvim",
    keys = {
      {
        "<leader>Ra",
        "<cmd>lua require('kulala').set_selected_env()<cr>",
        desc = "Set selected request as current",
        ft = "http",
      },
    },
    opts = { default_env = "test" },
  },
  -- -- Typr for warm-up
  -- {
  --   "nvzone/typr",
  --   dependencies = "nvzone/volt",
  --   opts = {},
  --   cmd = { "Typr", "TyprStats" },
  -- },
  { "andweeb/presence.nvim" },
}
