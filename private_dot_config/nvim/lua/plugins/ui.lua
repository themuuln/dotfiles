return {
  -- set default theme here
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "onedark" },
  },

  -- Installed Themes
  { "folke/tokyonight.nvim", opts = { transparent = true } },
  { "AlexvZyl/nordic.nvim", opts = { transparent = { bg = true, float = true } } },
  {
    "navarasu/onedark.nvim",
    opts = {
      transparent = true,
      toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" },
      code_style = { keywords = "italic" },
      lualine = { transparent = false },
    },
  },
  { "craftzdog/solarized-osaka.nvim" },
  { "rebelot/kanagawa.nvim" },
  { "projekt0n/github-nvim-theme" },
  { "rose-pine/neovim" },
  { "Mofiqul/vscode.nvim" },
  { "oxfist/night-owl.nvim" },
  { "ramojus/mellifluous.nvim" },
  { "atmosuwiryo/vim-winteriscoming" },
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        sections = {
          { section = "keys", gap = 1, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          {
            pane = 2,
            icon = " ",
            desc = "Browse Repo",
            padding = 1,
            key = "b",
            action = function()
              Snacks.gitbrowse()
            end,
          },
          function()
            local in_git = Snacks.git.get_root() ~= nil
            local cmds = {
              {
                title = "Notifications",
                cmd = "gh notify -s -a -n5",
                action = function()
                  vim.ui.open("https://github.com/notifications")
                end,
                key = "n",
                icon = " ",
                height = 5,
                enabled = true,
              },
              -- FIX: Not integrated with Gitlab
              -- {
              --   title = "Open Issues",
              --   cmd = "gh issue list -L 3",
              --   key = "i",
              --   action = function()
              --     vim.fn.jobstart("gh issue list --web", { detach = true })
              --   end,
              --   icon = " ",
              --   height = 7,
              -- },
              -- {
              --   icon = " ",
              --   title = "Open PRs",
              --   cmd = "gh pr list -L 3",
              --   key = "P",
              --   action = function()
              --     vim.fn.jobstart("gh pr list --web", { detach = true })
              --   end,
              --   height = 7,
              -- },
              {
                icon = " ",
                title = "Git Status",
                cmd = "git --no-pager diff --stat -B -M -C",
                height = 10,
              },
            }
            return vim.tbl_map(function(cmd)
              return vim.tbl_extend("force", {
                pane = 2,
                section = "terminal",
                enabled = in_git,
                padding = 1,
                ttl = 5 * 60,
                indent = 3,
              }, cmd)
            end, cmds)
          end,
        },
        animate = { fps = 120 },
        cursor = { enable = false },
      },
    },
  },
}
