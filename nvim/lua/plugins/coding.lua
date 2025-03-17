return {
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        mode = "tabs",
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
  },
  { "mg979/vim-visual-multi" },
  {
    "themuuln/crsnip.nvim",
    config = function()
      require("crsnip").setup({
        options = {
          snippet_dir = vim.fn.stdpath("config") .. "/snippets",
          debug = true,
        },
      })

      vim.keymap.set("n", "<leader>cb", "<cmd>CRSnip<CR>", { desc = "Create snippet" })
      vim.keymap.set("v", "<leader>cb", ":CRSnip<CR>", { desc = "Create snippet from selection" })
    end,
  },
}
