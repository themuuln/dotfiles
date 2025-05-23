return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    opts = {
      provider = "flash_500",
      vendors = {
        pro = {
          __inherited_from = "gemini",
          model = "gemini-2.5-pro-preview-05-06",
          api_key_name = "GEMINI_API",
          timeout = 30000,
          temperature = 0,
        },
        flash_500 = {
          __inherited_from = "gemini",
          model = "gemini-2.5-flash-preview-04-17",
          api_key_name = "GEMINI_API",
          timeout = 30000,
          temperature = 0,
          -- generationConfig = {
          --   thinkingConfig = {
          --     thinkingBudget = 1024,
          --   },
          -- },
        },
        flash_1500 = {
          __inherited_from = "gemini",
          model = "gemini-2.0-flash",
          api_key_name = "GEMINI_API",
          timeout = 30000,
          temperature = 0,
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
