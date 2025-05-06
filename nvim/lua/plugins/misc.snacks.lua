return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      animate = {
        fps = 120,
        easing = "inOutCubic",
      },
      explorer = {
        enabled = false,
      },
      image = {
        enabled = true,
        doc = {
          inline = false,
        },
      },
      scroll = {
        animate = {
          duration = { step = 10, total = 150 },
        },
      },
      bigfile = {
        enabled = true,
        notify = true,
      },
      debug = { enabled = true },
      dashboard = {
        --                                              
        --       ████ ██████           █████      ██
        --      ███████████             █████ 
        --      █████████ ███████████████████ ███   ███████████
        --     █████████  ███    █████████████ █████ ██████████████
        --    █████████ ██████████ █████████ █████ █████ ████ █████
        --  ███████████ ███    ███ █████████ █████ █████ ████ █████
        -- ██████  █████████████████████ ████ █████ █████ ████ ██████
        sections = {

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
                icon = " ",
                title = "Git Status",
                cmd = "git --no-pager diff --stat -B -M -C",
                pane = 2,
              },
            }
            return vim.tbl_map(function(cmd)
              return vim.tbl_extend("force", {
                section = "terminal",
                enabled = in_git,
                padding = 1,
                ttl = 5 * 60,
                indent = 3,
              }, cmd)
            end, cmds)
          end,
        },
      },
    },
  },
}
