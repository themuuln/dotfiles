return {
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
    opts = {
      -- split, float
      -- default_view = "headers_body",
      -- dev, test, prod, can be anything
      default_env = "test",
    },
  },
}
