return {
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
}
