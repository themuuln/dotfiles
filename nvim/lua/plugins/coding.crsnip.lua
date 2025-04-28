return {
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
