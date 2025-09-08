return {
  {
    "Exafunction/windsurf.vim",
    -- enabled = false,
    event = "BufEnter",
  },
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      -- Recommended for better prompt input, and required to use opencode.nvim's embedded terminal — otherwise optional
      { "folke/snacks.nvim", opts = { input = { enabled = true } } },
    },
    ---@type opencode.Opts
    opts = {
      -- Your configuration, if any — see lua/opencode/config.lua
    },
    keys = {
      -- Recommended keymaps
      {
        "<leader>oA",
        function()
          require("opencode").ask()
        end,
        desc = "Ask opencode",
      },
      {
        "<leader>oa",
        function()
          require("opencode").ask("@cursor: ")
        end,
        desc = "Ask opencode about this",
        mode = "n",
      },
      {
        "<leader>oa",
        function()
          require("opencode").ask("@selection: ")
        end,
        desc = "Ask opencode about selection",
        mode = "v",
      },
      {
        "<leader>ot",
        function()
          require("opencode").toggle()
        end,
        desc = "Toggle embedded opencode",
      },
      {
        "<leader>on",
        function()
          require("opencode").command("session_new")
        end,
        desc = "New session",
      },
      {
        "<leader>oy",
        function()
          require("opencode").command("messages_copy")
        end,
        desc = "Copy last message",
      },
      {
        "<S-C-u>",
        function()
          require("opencode").command("messages_half_page_up")
        end,
        desc = "Scroll messages up",
      },
      {
        "<S-C-d>",
        function()
          require("opencode").command("messages_half_page_down")
        end,
        desc = "Scroll messages down",
      },
      {
        "<leader>op",
        function()
          require("opencode").select_prompt()
        end,
        desc = "Select prompt",
        mode = { "n", "v" },
      },
      -- Example: keymap for custom prompt
      {
        "<leader>oe",
        function()
          require("opencode").prompt("Explain @cursor and its context")
        end,
        desc = "Explain code near cursor",
      },
    },
  },
  {
    "cousine/opencode-context.nvim",
    enabled = false,
    opts = {
      tmux_target = nil, -- Manual override: "session:window.pane"
      auto_detect_pane = true, -- Auto-detect opencode pane in current window
    },
    keys = {
      { "<leader>oc", "<cmd>OpencodeSend<cr>", desc = "Send prompt to opencode" },
      { "<leader>oc", "<cmd>OpencodeSend<cr>", mode = "v", desc = "Send prompt to opencode" },
      { "<leader>ot", "<cmd>OpencodeSwitchMode<cr>", desc = "Toggle opencode mode" },
      { "<leader>op", "<cmd>OpencodePrompt<cr>", desc = "Open opencode persistent prompt" },
    },
    cmd = { "OpencodeSend", "OpencodeSwitchMode" },
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    -- lazy = false,
    -- version = false,
    enabled = false,
    opts = {
      provider = "pro",
      behaviour = {
        enable_token_counting = false,

        -- claude model only
        enable_cursor_planning_mode = false,
        enable_claude_text_editor_tool_mode = false,
      },
      providers = {
        flash = {
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
        pro = {
          __inherited_from = "gemini",
          model = "gemini-2.5-pro",
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
