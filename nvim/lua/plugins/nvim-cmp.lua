return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "supermaven-inc/supermaven-nvim" },
    opts = function(_, opts)
      if vim.g.ai_cmp then
        table.insert(opts.sources, 1, {
          name = "supermaven",
          group_index = 1,
          priority = 100,
        })
      end
    end,
  },
}
