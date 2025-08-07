return {
  {
    "dinhhuy258/git.nvim",
    event = "BufReadPre",
  },
  {
    "harrisoncramer/gitlab.nvim",
    build = function()
      require("gitlab.server").build(true)
    end, -- Builds the Go binary
    config = function()
      require("gitlab").setup({
        auth_provider = function()
          return os.getenv("GITLAB_TOKEN"), os.getenv("GITLAB_VIM_URL"), nil
        end,
      })
    end,
  },
  { "sindrets/diffview.nvim" },
  -- { "tpope/vim-fugitive" },
}
