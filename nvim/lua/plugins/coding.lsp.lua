return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- toggle comments based on project
      ensure_installed = {
        -- must
        "lua",
        "regex",
        "vim",
        "yaml",
        "json",

        -- Web Development
        -- "html",
        -- "javascript",
        -- "typescript",
        -- "tsx",
        -- "astro",
        -- "css",

        -- flutter development
        "dart",

        -- other
        -- "http",
        -- "graphql",
        -- "markdown",
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
        -- 0. flutter development
        "dart-debug-adapter",

        -- 1. web development
        -- "prettier",
        -- "tailwindcss-language-server",
        -- "typescript-language-server",

        -- 2. must
        -- "json-lsp",
        -- "lua-language-server",

        -- 3. other
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
