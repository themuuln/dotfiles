return {
  {
    "LazyVim/LazyVim",
    -- opts = { colorscheme = "gruvbox-material" },
    -- opts = { colorscheme = "gruvbox" },
    -- opts = { colorscheme = "tokyonight" },
    -- opts = { colorscheme = "tokyonight-night" },
    -- opts = { colorscheme = "tokyonight-moon" },
    -- opts = { colorscheme = "catppuccin" },
    -- opts = { colorscheme = "catppuccin-macchiato" },
    -- opts = { colorscheme = "catppuccin-mocha" },
    -- opts = { colorscheme = "github_dark_default" },
    opts = { colorscheme = "kanagawa-dragon" },
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
  {
    "folke/tokyonight.nvim",
    opts = { transparent = true },
  },
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
  { "catppuccin/nvim", name = "catppuccin", opts = { transparent_background = true } },
  {
    "AlexvZyl/nordic.nvim",
    name = "nordic",
    -- opts = { transparent = { bg = true, float = true } },
  },
  -- recolor devicons to match theme
  {
    "rachartier/tiny-devicons-auto-colors.nvim",
    event = "UIEnter",
    -- dependencies = { { "nvim-tree/nvim-web-devicons", commit = "9154484705968658e9aab2b894d1b2a64bf9f83d" } },
    config = true,
  },

  -- main theme
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
  },
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
  -- { "oxfist/night-owl.nvim" },
  -- { "ramojus/mellifluous.nvim" },
  -- { "rafamadriz/neon" },
  -- { "kvrohit/mellow.nvim" },
  -- { "Everblush/everblush.nvim" },
  -- { "cryptomilk/nightcity.nvim" },
  { "navarasu/onedark.nvim" },
  { "sainnhe/gruvbox-material" },
  -- { "projekt0n/github-nvim-theme" },
  -- { "sainnhe/everforest" },
  -- { "Mofiqul/vscode.nvim" },
  -- { "olimorris/onedarkpro.nvim" },
  -- { "craftzdog/solarized-osaka.nvim" },
  -- { "shaunsingh/nord.nvim" },
  -- { "tiagovla/tokyodark.nvim" },
  { "sainnhe/edge" },
  -- { "rmehri01/onenord.nvim" },
  -- { "bluz71/vim-nightfly-colors" },
  -- { "eldritch-theme/eldritch.nvim" },
  -- { "mcchrish/zenbones.nvim" },
  -- { "olivercederborg/poimandres.nvim" },
  -- { "mhartington/oceanic-next" },
  -- { "dgox16/oldworld.nvim" },
  -- { "sho-87/kanagawa-paper.nvim" },
  { "HoNamDuong/hybrid.nvim" },
  -- { "rockyzhang24/arctic.nvim" },
  -- { "Yazeed1s/oh-lucy.nvim" },
  -- { "datsfilipe/vesper.nvim" },
  -- { "kvrohit/substrata.nvim" },
  -- { "rktjmp/lush.nvim" },
  {
    "mcauley-penney/techbase.nvim",
    priority = 1000,
    opts = {
      italic_comments = true,
      transparent = true,
    },
  },
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
    -- opts = function(_, opts)
    --   ---@type table<string, {updated:number, total:number, enabled: boolean, status:string[]}>
    --   local mutagen = {}
    --
    --   local function mutagen_status()
    --     local cwd = vim.uv.cwd() or "."
    --     mutagen[cwd] = mutagen[cwd]
    --       or {
    --         updated = 0,
    --         total = 0,
    --         enabled = vim.fs.find("mutagen.yml", { path = cwd, upward = true })[1] ~= nil,
    --         status = {},
    --       }
    --     local now = vim.uv.now() -- timestamp in milliseconds
    --     local refresh = mutagen[cwd].updated + 10000 < now
    --     if #mutagen[cwd].status > 0 then
    --       refresh = mutagen[cwd].updated + 1000 < now
    --     end
    --     if mutagen[cwd].enabled and refresh then
    --       ---@type {name:string, status:string, idle:boolean}[]
    --       local sessions = {}
    --       local lines = vim.fn.systemlist("mutagen project list")
    --       local status = {}
    --       local name = nil
    --       for _, line in ipairs(lines) do
    --         local n = line:match("^Name: (.*)")
    --         if n then
    --           name = n
    --         end
    --         local s = line:match("^Status: (.*)")
    --         if s then
    --           table.insert(sessions, {
    --             name = name,
    --             status = s,
    --             idle = s == "Watching for changes",
    --           })
    --         end
    --       end
    --       for _, session in ipairs(sessions) do
    --         if not session.idle then
    --           table.insert(status, session.name .. ": " .. session.status)
    --         end
    --       end
    --       mutagen[cwd].updated = now
    --       mutagen[cwd].total = #sessions
    --       mutagen[cwd].status = status
    --       if #sessions == 0 then
    --         vim.notify("Mutagen is not running", vim.log.levels.ERROR, { title = "Mutagen" })
    --       end
    --     end
    --     return mutagen[cwd]
    --   end
    --
    --   local error_color = { fg = Snacks.util.color("DiagnosticError") }
    --   local ok_color = { fg = Snacks.util.color("DiagnosticInfo") }
    --   opts.sections = opts.sections or {}
    --   opts.sections.lualine_x = opts.sections.lualine_x or {}
    --   table.insert(opts.sections.lualine_x, {
    --     function()
    --       local s = mutagen_status()
    --       local msg = tostring(s.total)
    --       if #s.status > 0 then
    --         msg = msg .. " | " .. table.concat(s.status, " | ")
    --       end
    --       return (s.total == 0 and "󰋘 " or "󰋙 ") .. msg
    --     end,
    --     cond = function()
    --       return mutagen_status().enabled
    --     end,
    --     color = function()
    --       return (mutagen_status().total == 0 or mutagen_status().status[1]) and error_color or ok_color
    --     end,
    --   })
    --
    --   opts.tabline = opts.tabline or {}
    --   opts.tabline.lualine_a = opts.tabline.lualine_a or {}
    --   opts.tabline.lualine_z = opts.tabline.lualine_z or {}
    --   table.insert(opts.tabline.lualine_a, {
    --     "buffers",
    --     mode = 0,
    --     use_mode_colors = true,
    --     symbols = { alternate_file = "" },
    --   })
    --   table.insert(opts.tabline.lualine_z, {
    --     "tabs",
    --     tab_max_length = 40,
    --     max_length = vim.o.columns / 3,
    --     mode = 0,
    --     path = 0,
    --     use_mode_colors = true,
    --     show_modified_status = true,
    --     symbols = { modified = " " },
    --     fmt = function(name, context)
    --       local buflist = vim.fn.tabpagebuflist(context.tabnr)
    --       local winnr = vim.fn.tabpagewinnr(context.tabnr)
    --       local bufnr = buflist[winnr]
    --       local mod = vim.fn.getbufvar(bufnr, "&mod")
    --       return name .. (mod == 1 and " +" or "")
    --     end,
    --   })
    -- end,
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

-- local function countLspRefs()
--   local icon = "󰈽" -- CONFIG
--
--   local client = vim.lsp.get_clients({ method = "textDocument/references", bufnr = 0 })[1]
--   if not client then
--     return ""
--   end
--
--   -- prevent multiple requests on still cursor without the need of autocmds
--   local row, col = unpack(vim.api.nvim_win_get_cursor(0))
--   local sameCursorPos = row == vim.b.lspReference_lastRow and col == vim.b.lspReference_lastCol
--
--   if not sameCursorPos then
--     vim.b.lspReference_lastRow, vim.b.lspReference_lastCol = row, col
--
--     local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
--     params.context = { includeDeclaration = true } ---@diagnostic disable-line: inject-field
--     local thisFile = params.textDocument.uri
--
--     client:request("textDocument/references", params, function(error, refs)
--       if error or not refs then -- not on a valid symbol, etc.
--         vim.b.lspReference_count = nil
--         return
--       end
--       local refsInFile = vim
--         .iter(refs)
--         :filter(function(r)
--           return thisFile == r.uri
--         end)
--         :totable()
--       local inFile, inWorkspace = #refsInFile - 1, #refs - 1 -- -1 for current occurrence
--       local text = inFile == inWorkspace and inFile or (inFile .. "(" .. inWorkspace .. ")")
--
--       vim.b.lspReference_count = inWorkspace > 0 and vim.trim(icon .. " " .. text) or nil
--     end)
--   end
--
--   return vim.b.lspReference_count or "" -- returns empty string at first and later the count
-- end

--------------------------------------------------------------------------------
