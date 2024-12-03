return {
  "mistweaverco/kulala.nvim",
  ft = "http",
  opts = {},
  keys = function()
    return {
      { "<leader>r", desc = "+rest" },
      {
        "<leader>rs",
        function()
          require("kulala").run()
        end,
        desc = "Send the request",
      },
      {
        "<leader>rt",
        function()
          require("kulala").toggle_view()
        end,
        desc = "Toggle headers/body",
      },
      {
        "<leader>rp",
        function()
          require("kulala").jump_prev()
        end,
        desc = "Jump to previous request",
      },
      {
        "<leader>rn",
        function()
          require("kulala").jump_next()
        end,
        desc = "Jump to next request",
      },
    }
  end,
}
