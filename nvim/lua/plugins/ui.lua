return {
  {
    "LazyVim/LazyVim",
    -- opts = { colorscheme = "gruvbox-material" },
    -- opts = { colorscheme = "gruvbox" },
    -- opts = { colorscheme = "tokyonight" },
    -- opts = { colorscheme = "tokyonight-night" },
    -- opts = { colorscheme = "tokyonight-moon" },
    -- opts = { colorscheme = "catppuccin" },
    opts = { colorscheme = "catppuccin-macchiato" },
    -- opts = { colorscheme = "catppuccin-mocha" },
    -- opts = { colorscheme = "github_dark_default" },
    -- opts = { colorscheme = "kanagawa-dragon" },
    -- opts = { colorscheme = "kanagawa-paper-ink" },
    -- opts = { colorscheme = "nordic" },
    -- opts = { colorscheme = "edge" },
    -- opts = { colorscheme = "onedark" },
    -- opts = { colorscheme = "solarized-osaka" },
    -- opts = { colorscheme = "techbase" },
    -- opts = { colorscheme = "hybrid" },
    -- opts = { colorscheme = "vague" },
    -- opts = { colorscheme = "rose-pine-main" },
  },
  { "folke/tokyonight.nvim" },
  { "catppuccin/nvim", name = "catppuccin", opts = { transparent_background = false } },
  { "AlexvZyl/nordic.nvim", name = "nordic" },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      variant = "main", -- auto, main, moon, or dawn
      dark_variant = "moon", -- main, moon, or dawn
      dim_inactive_windows = false,
      extend_background_behind_borders = true,

      enable = {
        terminal = true,
        legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
        migrations = true, -- Handle deprecated options automatically
      },

      styles = {
        bold = false,
        italic = false,
        transparency = true,
      },

      groups = {
        border = "muted",
        link = "iris",
        panel = "surface",

        error = "love",
        hint = "iris",
        info = "foam",
        note = "pine",
        todo = "rose",
        warn = "gold",

        git_add = "foam",
        git_change = "rose",
        git_delete = "love",
        git_dirty = "rose",
        git_ignore = "muted",
        git_merge = "iris",
        git_rename = "pine",
        git_stage = "iris",
        git_text = "rose",
        git_untracked = "subtle",

        h1 = "iris",
        h2 = "foam",
        h3 = "rose",
        h4 = "gold",
        h5 = "pine",
        h6 = "foam",
      },

      palette = {
        -- Override the builtin palette per variant
        -- moon = {
        --     base = '#18191a',
        --     overlay = '#363738',
        -- },
      },

      -- NOTE: Highlight groups are extended (merged) by default. Disable this
      -- per group via `inherit = false`
      highlight_groups = {
        -- Comment = { fg = "foam" },
        -- StatusLine = { fg = "love", bg = "love", blend = 15 },
        -- VertSplit = { fg = "muted", bg = "muted" },
        -- Visual = { fg = "base", bg = "text", inherit = false },
      },

      before_highlight = function(group, highlight, palette)
        -- Disable all undercurls
        -- if highlight.undercurl then
        --     highlight.undercurl = false
        -- end
        --
        -- Change palette colour
        -- if highlight.fg == palette.pine then
        --     highlight.fg = palette.foam
        -- end
      end,
    },
  },

  -- main theme
  {
    "rebelot/kanagawa.nvim",
    opts = {
      compile = true, -- enable compiling the colorscheme
      undercurl = true, -- enable undercurls
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = false },
      statementStyle = { bold = false },
      typeStyle = {},
      transparent = false, -- do not set background color
      dimInactive = false, -- dim inactive window `:h hl-NormalNC`
      terminalColors = true, -- define vim.g.terminal_color_{0,17}
      theme = "dragon", -- Load "wave" theme
      background = { -- map the value of 'background' option to a theme
        dark = "dragon", -- try "dragon" !
        light = "dragon",
      },
    },
  },
  { "navarasu/onedark.nvim" },
  { "sainnhe/gruvbox-material" },
  { "sainnhe/edge" },
  { "HoNamDuong/hybrid.nvim" },
  {
    "vague2k/vague.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      -- transparent = true,
      bold = false,
      italic = true,
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "filename" },
        lualine_b = { "diagnostics" },
        lualine_c = {},
        lualine_x = { "lsp_status" },
        lualine_y = { "diff" },
        lualine_z = { "location" },
      },
      tabline = {
        lualine_a = {
          {
            "buffers",
            hide_filename_extension = true,
            max_length = vim.o.columns * 2 / 3,
            use_mode_colors = true,
            symbols = { alternate_file = "" },
          },
        },
        lualine_b = {},
        lualine_z = {
          { "tabs", use_mode_colors = true, symbols = { modified = "●" } },
        },
      },
    },
  },

  {
    "folke/noice.nvim",
    opts = function(_, opts)
      opts.debug = vim.uv.cwd():find("noice%.nvim")
      opts.debug = false
      opts.routes = opts.routes or {}
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
      local focused = true
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          focused = false
        end,
      })

      table.insert(opts.routes, 1, {
        filter = {
          ["not"] = {
            event = "lsp",
            kind = "progress",
          },
          cond = function()
            return not focused and false
          end,
        },
        view = "notify_send",
        opts = { stop = false, replace = true },
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(event)
          vim.schedule(function()
            require("noice.text.markdown").keys(event.buf)
          end)
        end,
      })
      return opts
    end,
  },
}
