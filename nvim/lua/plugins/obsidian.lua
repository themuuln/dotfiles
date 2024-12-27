return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "theCoding",
        path = "/Users/ict/Library/Mobile Documents/iCloud~md~obsidian/Documents/home/notes",
      },
    },
    notes_subdir = "inbox",
    new_notes_location = "notes_subdir",

    disable_frontmatter = true,
    templates = {
      subdir = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M:%S",
    },

    mappings = {
      -- overrides the 'gf' mapping to work on markdown/wiki links within your vault
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- toggle check-boxes
      ["<leader>ti"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
    },
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },
    ui = {
      -- Disable some things below here because I set these manually for all Markdown files using treesitter
      checkboxes = {},
      bullets = {},
    },
  },
}
