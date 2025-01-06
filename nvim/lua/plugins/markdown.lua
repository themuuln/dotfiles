return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "coding",
          path = "/Users/ict/Library/Mobile Documents/iCloud~md~obsidian/Documents/Home/notes",
        },
      },
      notes_subdir = "nvim",
      new_notes_location = "nvim_subdir",

      disable_frontmatter = true,
    },
  },
  { "preservim/vim-markdown" },
  { "epwalsh/pomo.nvim" },
}
