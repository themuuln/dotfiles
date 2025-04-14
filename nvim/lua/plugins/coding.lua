return {
  {
    "akinsho/bufferline.nvim",
    opts = { options = { mode = "tabs", show_buffer_close_icons = false, show_close_icon = false } },
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
  {
    "echasnovski/mini.move",
    version = false,
    opts = {
      mappings = {
        left = "<A-Left>",
        right = "<A-Right>",
        down = "<A-Down>",
        up = "<A-Up>",

        line_left = "<A-Left>",
        line_right = "<A-Right>",
        line_down = "<A-Down>",
        line_up = "<A-Up>",
      },
    },
  },
  { "sindrets/diffview.nvim" },
}
