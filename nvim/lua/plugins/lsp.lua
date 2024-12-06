return {
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
    opts = { ---@type lspconfig.options servers = { dartls = {} }, },
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
          "http",
          "graphql",
          "dart",
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
      "williamboman/mason.nvim",
      opts = { ensure_installed = { "stylua", "shellcheck", "shfmt", "flake8", "prettier", "dart-debug-adapter" } },
    },
  },
}
