require("obsidian").setup({
  workspaces = {
    { name = "personal", path = "/Users/ict/Library/Mobile Documents/iCloud~md~obsidian/Documents/Home/notes" },
  },
  notes_subdir = "06 - All Notes/",
  daily_notes = {
    default = false,
    folder = "97 - Daily Notes",
    date_format = "%Y-%m-%d",
    alias_format = "%B %-d, %Y",
    default_tags = { "daily-notes", tostring(os.date("%Y-%m")) },
    template = "ICT Цагийн хуудас",
  },

  templates = {
    default = false,
    folder = "05 - Templates",
    date_format = "%Y-%m-%d",
    time_format = "%H:%M",
    substitutions = {},
  },
  picker = {
    default = false,
    name = "fzf-lua",
    note_mappings = {
      default = false,
      new = "<C-x>",
      -- Insert a link to the selected note.
      insert_link = "<C-l>",
    },
    tag_mappings = {
      default = true,
      -- Add tag(s) to current note.
      tag_note = "<C-x>",
      -- Insert a tag at the current location.
      insert_tag = "<C-l>",
    },
  },
  completion = { default = false, nvim_cmp = false, min_chars = 2 },
  mappings = {
    default = true,
    -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
    ["gf"] = {
      action = function()
        return require("obsidian").util.gf_passthrough()
      end,
      opts = { noremap = false, expr = true, buffer = true },
    },
    -- Toggle check-boxes.
    ["<leader>ch"] = {
      action = function()
        return require("obsidian").util.toggle_checkbox()
      end,
      opts = { buffer = true },
    },
    -- Smart action depending on context, either follow link or toggle checkbox.
    ["<cr>"] = {
      action = function()
        return require("obsidian").util.smart_action()
      end,
      opts = { buffer = true, expr = true },
    },
  },
  new_notes_location = "06 - All Notes",
  preferred_link_style = "wiki",
  disable_frontmatter = true,
  use_advanced_uri = false,
  open_app_foreground = false,
})
