return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    opts = {
      provider = "flash_500",
      -- windows = { ask = { floating = true } },
      vendors = {
        pro = {
          __inherited_from = "gemini",
          model = "gemini-2.5-pro-preview-03-25",
          api_key_name = "GEMINI_API",
          timeout = 30000,
          temperature = 0,
          -- max_completion_tokens = 1048576,
          -- reasoning_effort = "high", -- low|medium|high, only used for reasoning models
        },
        flash_500 = {
          __inherited_from = "gemini",
          model = "gemini-2.5-flash-preview-04-17",
          api_key_name = "GEMINI_API",
          timeout = 30000,
          temperature = 0,
          -- max_completion_tokens = 1048576,
          -- reasoning_effort = "low", -- low|medium|high, only used for reasoning models
        },
        flash_1500 = {
          __inherited_from = "gemini",
          model = "gemini-2.0-flash",
          api_key_name = "GEMINI_API",
          timeout = 30000,
          temperature = 0,
          -- max_completion_tokens = 1048576,
          -- reasoning_effort = "low", -- low|medium|high, only used for reasoning models
        },
      },
      behaviour = {
        -- auto_suggestions = false,
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
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = { "markdown", "Avante" },
    },
    ft = { "markdown", "Avante" },
  },
}
