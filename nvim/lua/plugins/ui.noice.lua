return {
  {
    "folke/noice.nvim",
    opts = {
      notify = {
        enabled = false, -- disables Noice's notification handler
      },
      lsp = {
        hover = {
          enabled = false, -- disables Noice's hover handler
        },
        signature = {
          enabled = false, -- disables Noice's signature help handler
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
          ["vim.lsp.util.stylize_markdown"] = false,
        },
      },
    },
  },
}
