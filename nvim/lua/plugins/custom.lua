return {
  { "folke/trouble.nvim", enabled = true },
  {
    "Exafunction/codeium.vim",
    event = "BufEnter",
  },

  { "epwalsh/obsidian.nvim", enabled = true },

  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        pyright = {},
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      init = function()
        require("lazyvim.util").lsp.on_attach(function(_, buffer)
          vim.keymap.set("n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
          vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
        end)
      end,
    },
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        tsserver = {},
      },
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        tsserver = function(_, opts)
          require("typescript").setup({ server = opts })
          return true
        end,
      },
    },
  },

  -- { import = "lazyvim.plugins.extras.lang.typescript" },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "tsx",
        "typescript",
      })
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, {
        function()
          return "💵"
        end,
      })
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
  },

  { import = "lazyvim.plugins.extras.ui.mini-starter" },

  { import = "lazyvim.plugins.extras.lang.json" },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "stylua", "shellcheck", "shfmt", "flake8" },
    },
  },

  {
    "dart-lang/dart-vim-plugin",
    ft = "dart",
    config = function()
      vim.g.dart_format_on_save = 1
      vim.g.dart_enable_hover = 1
      vim.g.dart_sdk_path = "/Users/ict/development/flutter/bin/cache/dart-sdk"
      vim.g.dartfmt_options = { "--line-length", "120" }
    end,
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" }, -- Ensure nvim-dap is loaded before this plugin
    config = function()
      -- Setup for nvim-dap-virtual-text to display inline variable values during debugging
      require("nvim-dap-virtual-text").setup({
        enabled = true, -- Enable virtual text
        enabled_commands = true, -- Enable DAP commands like `:DapVirtualTextToggle`
        highlight_changed_variables = true, -- Highlight changed variables with a different color
        show_stop_reason = true, -- Show why the debugger stopped (e.g., "Breakpoint hit")
        display_variable_name = true, -- Display variable names next to their values
      })
    end,
  },
}
