return {
  "akinsho/bufferline.nvim",
  keys = {
    { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next Tab" },
    { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev Tab" },
  },
  opts = {
    options = {
      mode = "tabs",
      show_buffer_close_icons = false,
      show_close_icon = false,
    },
  },
}
