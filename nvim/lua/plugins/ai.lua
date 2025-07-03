return {
  {
    "Exafunction/windsurf.vim",
    -- enabled = false,
    event = "BufEnter",
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    -- lazy = false,
    -- version = false,
    opts = {
      provider = "flash_500",
      behaviour = {
        enable_token_counting = false,

        -- claude model only
        enable_cursor_planning_mode = false,
        enable_claude_text_editor_tool_mode = false,
      },
      providers = {
        flash_500 = {
          __inherited_from = "gemini",
          model = "gemini-2.5-flash",
          api_key_name = "GEMINI_API",
          timeout = 60000,
          temperature = 0,
          -- generationConfig = {
          --   thinkingConfig = {
          --     thinkingBudget = 1024,
          --   },
          -- },
        },
        flash_500_2 = {
          __inherited_from = "gemini",
          model = "gemini-2.5-flash-preview-04-17",
          api_key_name = "GEMINI_API",
          timeout = 60000,
          temperature = 0,
          -- generationConfig = {
          --   thinkingConfig = {
          --     thinkingBudget = 1024,
          --   },
          -- },
        },
      },
    },
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
    init = function()
      -- Recommended option
      -- views can only be fully collapsed with the global statusline
      vim.opt.laststatus = 3
    end,
  },
}
