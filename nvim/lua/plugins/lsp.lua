return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- must
        "lua",
        "regex",
        "vim",
        "yaml",
        "json",
        -- "json5",
        -- Web Development
        "html",
        "javascript",
        "typescript",
        "tsx",
        "astro",
        "css",
        -- flutter development
        "dart",
        -- other
        "http",
        "graphql",
        "markdown",
        -- "markdown_inline",
        -- optional
        -- "python",
        -- "query",
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- flutter development
        "dart-debug-adapter",

        -- web development
        "prettier",
        "tailwindcss-language-server",
        "typescript-language-server",

        -- must
        "json-lsp",
        "lua-language-server",

        -- "stylua",
        -- "shellcheck",
        -- "shfmt",
        -- "flake8",
        -- "prettier",
      },
    },
  },
  {
    "nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = false,
      },
    },
  },
}
