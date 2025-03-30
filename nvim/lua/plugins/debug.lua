return {
  { "dart-lang/dart-vim-plugin" },
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    ft = "dart",
    config = function()
      require("flutter-tools").setup({
        debugger = {
          enabled = true,
          run_via_dap = true,
          evaluate_to_string_in_debug_views = true,
          register_configurations = function(_)
            local dap = require("dap")
            dap.adapters.dart = {
              type = "executable",
              command = "/Users/ict/development/flutter/bin/flutter",
              args = { "debug_adapter" },
            }
            dap.configurations.dart = {
              {
                type = "dart",
                request = "launch",
                name = "Launch Flutter",
                dartSdkPath = "/Users/ict/development/flutter/bin/cache/dart-sdk/bin/dart",
                flutterSdkPath = "/Users/ict/development/flutter/bin",
                program = "${workspaceFolder}/lib/main.dart",
                cwd = "${workspaceFolder}",
              },
            }
          end,
        },
        flutter_path = "/Users/ict/development/flutter/bin/flutter",
        widget_guides = { enabled = true },
        closing_tags = { highlight = "Comment", prefix = "//" },
        decorations = {
          statusline = {
            device = true,
            project_config = false,
          },
        },
        dev_log = {
          enabled = true,
          filter = nil, -- optional callback to filter the log
          notify_errors = true, -- if there is an error whilst running then notify the user
          open_cmd = "15split", -- command to use to open the log buffer
          focus_on_open = true, -- focus on the newly opened log window
        },
        lsp = {
          color = { enabled = true, background = true, virtual_text = true },
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            enableSnippets = true,
            updateImportsOnRename = true,
          },
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = { "nvim-neotest/nvim-nio", "rcarriga/nvim-dap-ui" },
    event = "VeryLazy",
    config = function()
      local dap = require("dap")
      dap.adapters.dart = {
        type = "executable",
        command = "/Users/ict/development/flutter/bin/flutter",
        args = { "debug_adapter" },
      }
      dap.configurations.dart = {
        -- Remove Comments for Dart Development
        {
          type = "dart",
          request = "launch",
          name = "Launch Flutter",
          program = "${workspaceFolder}/lib/main.dart",
          cwd = "${workspaceFolder}",
          flutterSdkPath = "/Users/ict/development/flutter/bin",
          dartSdkPath = "/Users/ict/development/flutter/bin/cache/dart-sdk/bin/dart",
          -- toolArgs = { "--hot-reload" },
          args = {},
        },
        {
          type = "dart",
          request = "attach",
          name = "Attach Flutter",
          dartSdkPath = "/Users/ict/development/flutter/bin/cache/dart-sdk/bin/dart",
          flutterSdkPath = "/Users/ict/development/flutter/bin",
          program = "${workspaceFolder}/lib/main.dart",
          cwd = "${workspaceFolder}",
          -- toolArgs = { "--hot-reload" },
        },
      }
    end,
  },
  {
    "williamboman/mason-nvim-dap.nvim",
    requires = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    config = function()
      require("mason-nvim-dap").setup()
    end,
  },
}
-- {
--   ui = {
--     -- the border type to use for all floating windows, the same options/formats
--     -- used for ":h nvim_open_win" e.g. "single" | "shadow" | {<table-of-eight-chars>}
--     border = "rounded",
--     -- This determines whether notifications are show with `vim.notify` or with the plugin's custom UI
--     -- please note that this option is eventually going to be deprecated and users will need to
--     -- depend on plugins like `nvim-notify` instead.
--     notification_style = 'native' | 'plugin'
--   },
--   decorations = {
--     statusline = {
--       -- set to true to be able use the 'flutter_tools_decorations.app_version' in your statusline
--       -- this will show the current version of the flutter app from the pubspec.yaml file
--       app_version = false,
--       -- set to true to be able use the 'flutter_tools_decorations.device' in your statusline
--       -- this will show the currently running device if an application was started with a specific
--       -- device
--       device = false,
--       -- set to true to be able use the 'flutter_tools_decorations.project_config' in your statusline
--       -- this will show the currently selected project configuration
--       project_config = false,
--     }
--   closing_tags = {
--     highlight = "ErrorMsg", -- highlight for the closing tag
--     prefix = ">", -- character to use for close tag e.g. > Widget
--     priority = 10, -- priority of virtual text in current line
--     -- consider to configure this when there is a possibility of multiple virtual text items in one line
--     -- see `priority` option in |:help nvim_buf_set_extmark| for more info
--     enabled = true -- set to false to disable
--   },
--   lsp = {
--     color = { -- show the derived colours for dart variables
--       enabled = false, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
--       background = false, -- highlight the background
--       background_color = nil, -- required, when background is transparent (i.e. background_color = { r = 19, g = 17, b = 24},)
--       foreground = false, -- highlight the foreground
--       virtual_text = true, -- show the highlight using virtual text
--       virtual_text_str = "■", -- the virtual text character to highlight
--     },
--     on_attach = my_custom_on_attach,
--     capabilities = my_custom_capabilities, -- e.g. lsp_status capabilities
--     --- OR you can specify a function to deactivate or change or control how the config is created
--     capabilities = function(config)
--       config.specificThingIDontWant = false
--       return config
--     end,
--     -- see the link below for details on each option:
--     -- https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/tool/lsp_spec/README.md#client-workspace-configuration
--     settings = {
--       showTodos = true,
--       completeFunctionCalls = true,
--       analysisExcludedFolders = {"<path-to-flutter-sdk-packages>"},
--       renameFilesWithClasses = "prompt", -- "always"
--       enableSnippets = true,
--       updateImportsOnRename = true, -- Whether to update imports and other directives when files are renamed. Required for `FlutterRename` command.
--     }
--   }
-- }
