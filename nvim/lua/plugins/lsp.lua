return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    opts = {
      inlay_hints = { enabled = true },
      diagnostics = { virtual_text = { prefix = "icons" } },
      capabilities = {
        workspace = {
          didChangeWatchedFiles = {
            dynamicRegistration = false,
          },
        },
      },
    },
  },

  { "stevearc/dressing.nvim" },

  -- {
  --   "nvim-flutter/flutter-tools.nvim",
  --   lazy = true,
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "stevearc/dressing.nvim",
  --   },
  --   ft = { "dart" },
  --   config = function()
  --     require("flutter-tools").setup({
  --       debugger = {
  --         enabled = true,
  --         run_via_dap = true,
  --         exception_breakpoints = {},
  --         -- evaluate_to_string_in_debug_views = false,
  --       },
  --       flutter_path = os.getenv("HOME") .. "/development/flutter/bin/flutter",
  --       default_run_args = nil, -- Default options for run command (i.e `{ flutter = "--no-version-check" }`). Configured separately for `dart run` and `flutter run`.
  --       -- widget_guides = { enabled = true },
  --       dev_log = { enabled = false },
  --       dev_tools = { autostart = false, auto_open_browser = false },
  --       lsp = {
  --         color = {
  --           enabled = false,
  --         },
  --         settings = {
  --           lineLength = 120,
  --           showTodos = false,
  --           completeFunctionCalls = false,
  --           renameFilesWithClasses = "prompt",
  --           enableSdkFormatter = true,
  --           analysisExcludedFolders = {
  --             os.getenv("HOME") .. "/development/flutter/packages",
  --             vim.fn.expand("$Home/.pub-cache"),
  --           },
  --         },
  --       },
  --     })
  --   end,
  -- },

  { "stevearc/conform.nvim", opts = {
    exclude_filetypes = { "dart" },
  } },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      local supported = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc" }
      for _, ft in ipairs(supported) do
        -- Try Biome first; if it’s not applicable, try Prettier
        opts.formatters_by_ft[ft] = { "biome", "prettier", stop_after_first = true }
      end
      opts.formatters = opts.formatters or {}
      opts.formatters.biome = {
        -- Only run when a project has a Biome config
        require_cwd = true, -- looks for biome.json/biome.jsonc from cwd
      }
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "caddy",
        "cmake",
        -- "dart",
        -- "comment", -- comments are slowing down TS bigtime, so disable for now
        "css",
        "devicetree",
        "gitcommit",
        "gitignore",
        "glsl",
        "go",
        "graphql",
        "http",
        "just",
        "kconfig",
        "meson",
        "ninja",
        "scss",
        -- "sql",
        "svelte",
        "vue",
        "wgsl",
      },
    },
  },
}
