return {
  { "mg979/vim-visual-multi" },
  { "echasnovski/mini.surround", version = false, opts = { n_lines = 100 } },
  {
    "echasnovski/mini.move",
    version = false,
    opts = {
      mappings = {
        left = "<A-Left>",
        right = "<A-Right>",
        down = "J",
        up = "K",

        line_left = "<A-Left>",
        line_right = "<A-Right>",
        line_down = "<A-Down>",
        line_up = "<A-Up>",
      },
    },
  },
}
