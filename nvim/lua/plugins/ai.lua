return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    opts = {
      provider = "gemini_pro",
      gemini = {
        model = "gemini-2.0-flash",
        -- model = "gemini-2.0-flash-thinking-exp-01-21",
        -- model = "gemini-2.5-pro-exp-03-25",
        api_key_name = "GEMINI_API",
        timeout = 60000,
        temperature = 0,
      },
      windows = {
        ask = {
          floating = true,
        },
      },
      vendors = {
        mistral_small = {
          __inherited_from = "openai",
          endpoint = "https://openrouter.ai/api/v1",
          api_key_name = "OPENROUTER_API",
          model = "mistralai/mistral-small-3.1-24b-instruct:free",
        },
        gemini_pro = {
          __inherited_from = "openai",
          endpoint = "https://openrouter.ai/api/v1",
          api_key_name = "OPENROUTER_API",
          model = "google/gemini-2.5-pro-exp-03-25:free",
        },
      },
      behaviour = {
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = true,
        support_paste_from_clipboard = true,
        minimize_diff = true,
        enable_token_counting = false,
        enable_cursor_planning_mode = true,
        enable_claude_text_editor_tool_mode = true,
      },
    },
    build = "make",
    dependencies = {
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = { insert_mode = true },
            use_absolute_path = true,
          },
        },
      },
    },
  },
}
