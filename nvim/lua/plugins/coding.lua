return {
  { "Exafunction/codeium.vim", event = "BufEnter" },
  -- supermaven
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "supermaven-inc/supermaven-nvim", "hrsh7th/cmp-emoji" },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
      if vim.g.ai_cmp then
        table.insert(opts.sources, 1, {
          name = "supermaven",
          group_index = 1,
          priority = 100,
        })
      end
    end,
  },
  {
    "supermaven-inc/supermaven-nvim",
    opts = {
      keymaps = {
        accept_suggestion = "<Tab>",
      },
      disable_inline_completion = vim.g.ai_cmp,
    },
  },
}
