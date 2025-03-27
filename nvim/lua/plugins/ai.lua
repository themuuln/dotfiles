return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    opts = {
      provider = "gemini",
      gemini = {
        -- model = "gemini-2.0-flash",
        -- model = "gemini-2.0-pro-exp-02-05",
        -- model = "gemini-2.0-flash-thinking-exp-01-21",
        model = "gemini-2.5-pro-exp-03-25",
        timeout = 30000,
        temperature = 0.3,
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
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true,
          },
        },
      },
    },
  },
}
