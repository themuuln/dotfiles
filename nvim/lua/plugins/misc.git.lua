return {
  {
    "dinhhuy258/git.nvim",
    event = "BufReadPre",
    opts = {
      keymaps = {
        -- Open blame window
        blame = "<Leader>gb",
        -- Open file/folder in git repository
        browse = "<Leader>go",
      },
    },
  },
  -- {
  --   "lewis6991/gitsigns.nvim",
  --   event = "LazyFile",
  --   opts = {
  --     current_line_blame = true,
  --     current_line_blame_opts = {
  --       delay = 0,
  --       virt_text_priority = 100,
  --       use_focus = true,
  --     },
  --   },
  -- },
  -- {
  --   "harrisoncramer/gitlab.nvim",
  --   build = function()
  --     require("gitlab.server").build(true)
  --   end, -- Builds the Go binary
  --   config = function()
  --     require("gitlab").setup({
  --       auth_provider = function()
  --         return os.getenv("GITLAB_TOKEN"), os.getenv("GITLAB_VIM_URL"), nil
  --       end,
  --     })
  --   end,
  -- },
  { "sindrets/diffview.nvim" },
  -- { "tpope/vim-fugitive" },
}
