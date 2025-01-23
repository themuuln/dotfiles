return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "html",
        "javascript",
        "lua",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
        "http",
        "graphql",
        "json",
        "dart",
        "markdown",
        "markdown_inline",
        "python",
        "query",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(
        opts.ensure_installed,
        { "tsx", "typescript", "dart", "javascript", "astro", "css", "html", "http", "json", "json5" }
      )
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
        "dart-debug-adapter",
        "json-lsp",
        "lua-language-server",
        "prettier",
        "tailwindcss-language-server",
        "typescript-language-server",
      },
    },
  },
}
