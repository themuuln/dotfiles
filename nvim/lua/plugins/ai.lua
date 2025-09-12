return {
  {
    "Exafunction/windsurf.vim",
    -- enabled = false,
    event = "BufEnter",
  },
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      { "folke/snacks.nvim", opts = { input = { enabled = true } } },
    },
    config = function()
      vim.g.opencode_opts = {}
      vim.opt.autoread = true

      vim.keymap.set("n", "<leader>ot", function()
        require("opencode").toggle()
      end, { desc = "Toggle opencode" })
      vim.keymap.set("n", "<leader>oA", function()
        require("opencode").ask()
      end, { desc = "Ask opencode" })
      vim.keymap.set("n", "<leader>oa", function()
        require("opencode").ask("@cursor: ")
      end, { desc = "Ask opencode about this" })
      vim.keymap.set("v", "<leader>oa", function()
        require("opencode").ask("@selection: ")
      end, { desc = "Ask opencode about selection" })
      vim.keymap.set("n", "<leader>on", function()
        require("opencode").command("session_new")
      end, { desc = "New opencode session" })
      vim.keymap.set("n", "<leader>oy", function()
        require("opencode").command("messages_copy")
      end, { desc = "Copy last opencode response" })
      vim.keymap.set("n", "<S-C-u>", function()
        require("opencode").command("messages_half_page_up")
      end, { desc = "Messages half page up" })
      vim.keymap.set("n", "<S-C-d>", function()
        require("opencode").command("messages_half_page_down")
      end, { desc = "Messages half page down" })
      vim.keymap.set({ "n", "v" }, "<leader>os", function()
        require("opencode").select()
      end, { desc = "Select opencode prompt" })

      vim.keymap.set("n", "<leader>oe", function()
        require("opencode").prompt("Explain @cursor and its context")
      end, { desc = "Explain this code" })
    end,
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
