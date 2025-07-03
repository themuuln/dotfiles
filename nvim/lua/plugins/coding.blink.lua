return {
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "enter",
        ["<C-g>"] = { "accept" },
        ["<C-d>"] = { "select_next" },
        ["<C-c>"] = { "select_prev" },
      },
      fuzzy = {
        -- Controls which implementation to use for the fuzzy matcher.
        --
        -- 'prefer_rust_with_warning' (Recommended) If available, use the Rust implementation, automatically downloading prebuilt binaries on supported systems. Fallback to the Lua implementation when not available, emitting a warning message.
        -- 'prefer_rust' If available, use the Rust implementation, automatically downloading prebuilt binaries on supported systems. Fallback to the Lua implementation when not available.
        -- 'rust' Always use the Rust implementation, automatically downloading prebuilt binaries on supported systems. Error if not available.
        -- 'lua' Always use the Lua implementation, doesn't download any prebuilt binaries
        --
        -- See the prebuilt_binaries section for controlling the download behavior
        implementation = "prefer_rust_with_warning",

        -- Allows for a number of typos relative to the length of the query
        -- Set this to 0 to match the behavior of fzf
        -- Note, this does not apply when using the Lua implementation.
        max_typos = function(keyword)
          return math.floor(#keyword / 4)
        end,

        -- Frecency tracks the most recently/frequently used items and boosts the score of the item
        -- Note, this does not apply when using the Lua implementation.
        use_frecency = true,

        -- Proximity bonus boosts the score of items matching nearby words
        -- Note, this does not apply when using the Lua implementation.
        use_proximity = true,

        -- UNSAFE!! When enabled, disables the lock and fsync when writing to the frecency database. This should only be used on unsupported platforms (i.e. alpine termux)
        -- Note, this does not apply when using the Lua implementation.
        use_unsafe_no_lock = false,

        -- Controls which sorts to use and in which order, falling back to the next sort if the first one returns nil
        -- You may pass a function instead of a string to customize the sorting
        sorts = {
          -- (optionally) always prioritize exact matches
          -- 'exact',

          -- pass a function for custom behavior
          -- function(item_a, item_b)
          --   return item_a.score > item_b.score
          -- end,

          "score",
          "sort_text",
        },

        prebuilt_binaries = {
          -- Whether or not to automatically download a prebuilt binary from github. If this is set to `false`,
          -- you will need to manually build the fuzzy binary dependencies by running `cargo build --release`
          -- Disabled by default when `fuzzy.implementation = 'lua'`
          download = true,

          -- Ignores mismatched version between the built binary and the current git sha, when building locally
          ignore_version_mismatch = false,

          -- When downloading a prebuilt binary, force the downloader to resolve this version. If this is unset
          -- then the downloader will attempt to infer the version from the checked out git tag (if any).
          --
          -- Beware that if the fuzzy matcher changes while tracking main then this may result in blink breaking.
          force_version = nil,

          -- When downloading a prebuilt binary, force the downloader to use this system triple. If this is unset
          -- then the downloader will attempt to infer the system triple from `jit.os` and `jit.arch`.
          -- Check the latest release for all available system triples
          --
          -- Beware that if the fuzzy matcher changes while tracking main then this may result in blink breaking.
          force_system_triple = nil,

          -- Extra arguments that will be passed to curl like { 'curl', ..extra_curl_args, ..built_in_args }
          extra_curl_args = {},

          proxy = {
            -- When downloading a prebuilt binary, use the HTTPS_PROXY environment variable
            from_env = true,

            -- When downloading a prebuilt binary, use this proxy URL. This will ignore the HTTPS_PROXY environment variable
            url = nil,
          },
        },
      },
      cmdline = {
        -- keymap = {
        --   preset = "inherit",
        --   ["<Tab>"] = { "show", "accept", "fallback" },
        -- },
        completion = { menu = { auto_show = true }, ghost_text = { enabled = true } },
      },
      -- Experimental signature help support
      signature = {
        enabled = true,
        trigger = {
          -- Show the signature help automatically
          enabled = true,
          -- Show the signature help window after typing any of alphanumerics, `-` or `_`
          show_on_keyword = true,
          blocked_trigger_characters = {},
          blocked_retrigger_characters = {},
          -- Show the signature help window after typing a trigger character
          show_on_trigger_character = true,
          -- Show the signature help window when entering insert mode
          show_on_insert = true,
          -- Show the signature help window when the cursor comes after a trigger character when entering insert mode
          show_on_insert_on_trigger_character = true,
        },
        window = {
          min_width = 1,
          max_width = 100,
          max_height = 10,
          border = nil, -- Defaults to `vim.o.winborder` on nvim 0.11+ or 'padded' when not defined/<=0.10
          winblend = 0,
          winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
          scrollbar = false, -- Note that the gutter will be disabled when border ~= 'none'
          -- Which directions to show the window,
          -- falling back to the next direction when there's not enough space,
          -- or another window is in the way
          direction_priority = { "n", "s" },
          -- Can accept a function if you need more control
          -- direction_priority = function()
          --   if condition then return { 'n', 's' } end
          --   return { 's', 'n' }
          -- end,

          -- Disable if you run into performance issues
          treesitter_highlighting = true,
          show_documentation = true,
        },
      },
      completion = {
        trigger = {
          -- When true, will prefetch the completion items when entering insert mode
          prefetch_on_insert = true,

          -- When false, will not show the completion window automatically when in a snippet
          show_in_snippet = true,

          -- When true, will show completion window after backspacing
          show_on_backspace = false,

          -- When true, will show completion window after backspacing into a keyword
          show_on_backspace_in_keyword = false,

          -- When true, will show the completion window after accepting a completion and then backspacing into a keyword
          show_on_backspace_after_accept = true,

          -- When true, will show the completion window after entering insert mode and backspacing into keyword
          show_on_backspace_after_insert_enter = true,

          -- When true, will show the completion window after typing any of alphanumerics, `-` or `_`
          show_on_keyword = true,

          -- When true, will show the completion window after typing a trigger character
          show_on_trigger_character = true,

          -- When true, will show the completion window after entering insert mode
          show_on_insert = true,

          -- LSPs can indicate when to show the completion window via trigger characters
          -- however, some LSPs (i.e. tsserver) return characters that would essentially
          -- always show the window. We block these by default.
          show_on_blocked_trigger_characters = { " ", "\n", "\t" },
          -- You can also block per filetype with a function:
          -- show_on_blocked_trigger_characters = function(ctx)
          --   if vim.bo.filetype == 'markdown' then return { ' ', '\n', '\t', '.', '/', '(', '[' } end
          --   return { ' ', '\n', '\t' }
          -- end,

          -- When both this and show_on_trigger_character are true, will show the completion window
          -- when the cursor comes after a trigger character after accepting an item
          show_on_accept_on_trigger_character = true,

          -- When both this and show_on_trigger_character are true, will show the completion window
          -- when the cursor comes after a trigger character when entering insert mode
          show_on_insert_on_trigger_character = true,

          -- List of trigger characters (on top of `show_on_blocked_trigger_characters`) that won't trigger
          -- the completion window when the cursor comes after a trigger character when
          -- entering insert mode/accepting an item
          show_on_x_blocked_trigger_characters = { "'", '"', "(" },
          -- or a function, similar to show_on_blocked_trigger_character
        },
        list = {
          -- Maximum number of items to display
          max_items = 200,

          selection = {
            -- When `true`, will automatically select the first item in the completion list
            preselect = true,
            -- preselect = function(ctx) return vim.bo.filetype ~= 'markdown' end,

            -- When `true`, inserts the completion item automatically when selecting it
            -- You may want to bind a key to the `cancel` command (default <C-e>) when using this option,
            -- which will both undo the selection and hide the completion menu
            auto_insert = true,
            -- auto_insert = function(ctx) return vim.bo.filetype ~= 'markdown' end
          },

          cycle = {
            -- When `true`, calling `select_next` at the _bottom_ of the completion list
            -- will select the _first_ completion item.
            from_bottom = true,
            -- When `true`, calling `select_prev` at the _top_ of the completion list
            -- will select the _last_ completion item.
            from_top = true,
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 100,
          treesitter_highlighting = true,
        },
        accept = {
          -- auto_brackets = { semantic_token_resolution = { blocked_filetypes = { "typescriptreact", "typescript" } } },
          -- Write completions to the `.` register
          dot_repeat = true,
          -- Create an undo point when accepting a completion item
          create_undo_point = true,
          -- How long to wait for the LSP to resolve the item with additional information before continuing as-is
          resolve_timeout_ms = 100,
          -- Experimental auto-brackets support
          auto_brackets = {
            -- Whether to auto-insert brackets for functions
            enabled = true,
            -- Default brackets to use for unknown languages
            default_brackets = { "(", ")" },
            -- Overrides the default blocked filetypes
            -- See: https://github.com/Saghen/blink.cmp/blob/main/lua/blink/cmp/completion/brackets/config.lua#L5-L9
            override_brackets_for_filetypes = {},
            -- Synchronously use the kind of the item to determine if brackets should be added
            kind_resolution = {
              enabled = true,
              blocked_filetypes = { "typescriptreact", "javascriptreact", "vue" },
            },
            -- Asynchronously use semantic token to determine if brackets should be added
            semantic_token_resolution = {
              enabled = true,
              blocked_filetypes = { "java" },
              -- How long to wait for semantic tokens to return before assuming no brackets should be added
              timeout_ms = 400,
            },
          },
        },
        ghost_text = {
          enabled = true,
          -- Show the ghost text when an item has been selected
          show_with_selection = true,
          -- Show the ghost text when no item has been selected, defaulting to the first item
          show_without_selection = false,
          -- Show the ghost text when the menu is open
          show_with_menu = true,
          -- Show the ghost text when the menu is closed
          show_without_menu = true,
        },
      },
    },
    -- opts_extend = { "sources.default" },
  },
  -- {
  --   "saghen/blink.cmp",
  --   ---@module 'blink.cmp'
  --   ---@type blink.cmp.Config
  --   opts = {
  --     completion = {
  --       -- accept = { auto_brackets = { enabled = true } },
  --       -- list = {
  --       --   selection = {
  --       --     auto_insert = false,
  --       --     preselect = true,
  --       --   },
  --       -- },
  --       documentation = {
  --         auto_show = true,
  --         -- auto_show_delay_ms = 100,
  --         treesitter_highlighting = true,
  --       },
  --       ghost_text = {
  --         enabled = true,
  --         show_without_selection = true,
  --       },
  --       menu = {
  --         scrollbar = true,
  --         auto_show = true,
  --         draw = {
  --           components = {
  --             kind_icon = {
  --               text = function(ctx)
  --                 local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
  --                 return kind_icon
  --               end,
  --               highlight = function(ctx)
  --                 local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
  --                 return hl
  --               end,
  --             },
  --             kind = {
  --               highlight = function(ctx)
  --                 local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
  --                 return hl
  --               end,
  --             },
  --           },
  --         },
  --       },
  --     },
  --     signature = {
  --       enabled = true,
  --       trigger = {
  --         enabled = true,
  --         show_on_keyword = false,
  --         show_on_insert = true,
  --         show_on_insert_on_trigger_character = true,
  --       },
  --     },
  --   },
  -- },
}
