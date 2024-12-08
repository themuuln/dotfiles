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
          -- for web development
          "html",
          "javascript",
          -- for basic vim configuartion
          "lua",
          -- Enable this if you want to use tsx and typescript
          "regex",
          -- "tsx",
          -- "typescript",
          "vim",
          "yaml",
          -- kulala.nvim requirement
          "http",
          "graphql",
          "json",
          -- flutter development
          "dart",
          -- notetaking
          "markdown",
          "markdown_inline",
          -- "python",
          -- "query",
        },
      },
    },

    {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        -- add tsx and treesitter
        vim.list_extend(opts.ensure_installed, {
          -- if you'll use typesript uncomment the following
          -- "tsx",
          -- "typescript",
          --
          -- Flutter Development
          "dart",
        })
      end,
    },

    {
      "williamboman/mason.nvim",
      opts = {
        ensure_installed = {
          "stylua",
          "shellcheck",
          "shfmt",
          "flake8",
          "prettier",
          -- dart-debug-adapter
          -- dcm
          -- json-lsp
          -- lua-language-server
          -- markdown-toc
          -- markdownlint-cli2
          -- marksman
          -- prettier
          -- shfmt
          -- stylua
          -- tailwindcss-language-server
          -- typescript-language-server

          -- flutter development
          "dart-debug-adapter",
          -- ast-grep
          -- flake8
        },
      },
    },
  },
}
