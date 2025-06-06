return {
  {
    "yetone/avante.nvim",
    enabled = true,
    event = "VeryLazy",
    opts = {
      provider = "flash_500",
      providers = {
        flash_500 = {
          __inherited_from = "gemini",
          model = "gemini-2.5-flash-preview-05-20",
          api_key_name = "GEMINI_API",
          timeout = 30000,
          temperature = 0,
          -- generationConfig = {
          --   thinkingConfig = {
          --     thinkingBudget = 1024,
          --   },
          -- },
        },
      },
      behaviour = {
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = true,
        minimize_diff = true,
        enable_token_counting = false,
        -- claude model only
        enable_cursor_planning_mode = false,
        enable_claude_text_editor_tool_mode = false,
      },
    },
    build = "make",
  },
}
