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

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "stylua", "shellcheck", "shfmt", "flake8" },
    },
  },
  -- {
  --   "nvim-focus/focus.nvim",
  --   config = function()
  --     require("focus").setup({
  --       autoresize = {
  --         enable = true,
  --         width = 0, -- Automatically calculated based on golden ratio
  --         minwidth = 4, -- Minimum width for unfocused windows
  --         height = 0, -- Automatically calculated based on golden ratio
  --         minheight = 1, -- Minimum height for unfocused windows
  --       },
  --       ui = {
  --         number = false, -- Disable line numbers in unfocused windows
  --         relativenumber = false, -- Disable relative numbers in unfocused windows
  --         cursorline = true, -- Enable cursorline in focused window only
  --         signcolumn = false, -- Disable signcolumn in unfocused windows
  --       },
  --     })
  --   end,
  --   event = "VeryLazy", -- Load the plugin during startup for optimal performance
  -- },
}
