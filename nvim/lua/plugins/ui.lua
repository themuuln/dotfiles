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
    opts = { colorscheme = "catppuccin-mocha" },
    -- opts = { colorscheme = "github_dark_default" },
    -- opts = { colorscheme = "kanagawa-dragon" },
    -- opts = { colorscheme = "kanagawa-paper-ink" },
    -- opts = { colorscheme = "nordic" },
    -- opts = { colorscheme = "vscode" },
    -- opts = { colorscheme = "nord" },
    -- opts = { colorscheme = "edge" },
    -- opts = { colorscheme = "onedark" },
    -- opts = { colorscheme = "solarized-osaka" },
    -- opts = { colorscheme = "techbase" },
    -- opts = { colorscheme = "hybrid" },
    -- opts = { colorscheme = "vague" },
    -- opts = { colorscheme = "rose-pine-main" },
  },
  -- { "folke/tokyonight.nvim", opts = { transparent = true } },

  { "catppuccin/nvim", name = "catppuccin", opts = { transparent_background = false } },

  {
    "thesimonho/kanagawa-paper.nvim",
    lazy = false,
    priority = 1000,
    opts = function()
      local colors = require("kanagawa-paper.colors")
      local palette_colors = colors.palette
      return {
        transparent = true,
        diag_background = true,
        colors = {
          theme = {
            ink = {
              ui = {},
            },
          },
        },
      }
    end,
  },

  -- { "shaunsingh/nord.nvim" },
  {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    priority = 1000,
  },

  -- main theme
  {
    "rebelot/kanagawa.nvim",
    -- opts = {
    --   compile = true, -- enable compiling the colorscheme
    --   undercurl = true, -- enable undercurls
    --   commentStyle = { italic = true },
    --   functionStyle = {},
    --   keywordStyle = { italic = false },
    --   statementStyle = { bold = false },
    --   typeStyle = {},
    --   transparent = false, -- do not set background color
    --   dimInactive = false, -- dim inactive window `:h hl-NormalNC`
    --   terminalColors = true, -- define vim.g.terminal_color_{0,17}
    --   theme = "dragon", -- Load "wave" theme
    --   background = { -- map the value of 'background' option to a theme
    --     dark = "dragon", -- try "dragon" !
    --     light = "dragon",
    --   },
    -- },
  },
  -- { "navarasu/onedark.nvim" },
  -- { "sainnhe/gruvbox-material" },
  -- { "sainnhe/edge" },
  -- { "HoNamDuong/hybrid.nvim" },
  -- {
  --   "vague2k/vague.nvim",
  --   lazy = true,
  --   priority = 1000,
  --   opts = {
  --     -- transparent = true,
  --     bold = false,
  --     italic = true,
  --   },
  -- },

  -- {
  --   "nvim-lualine/lualine.nvim",
  --   opts = {
  --     options = {
  --       icons_enabled = true,
  --       theme = "auto",
  --       component_separators = { left = "", right = "" },
  --       section_separators = { left = "", right = "" },
  --     },
  --     -- -- bufferline replacement
  --     -- tabline = {
  --     --   lualine_a = {
  --     --     {
  --     --       "buffers",
  --     --       hide_filename_extension = true,
  --     --       max_length = vim.o.columns * 2 / 3,
  --     --       use_mode_colors = true,
  --     --       symbols = { alternate_file = "" },
  --     --     },
  --     --   },
  --     --   lualine_b = {},
  --     --   lualine_z = {
  --     --     { "tabs", use_mode_colors = true, symbols = { modified = "●" } },
  --     --   },
  --     -- },
  --     sections = {
  --       lualine_a = { "filename" },
  --       lualine_b = { "diagnostics" },
  --       lualine_c = {},
  --       lualine_x = {},
  --       lualine_y = { "diff" },
  --       lualine_z = { "location" },
  --     },
  --   },
  -- },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      ---@type table<string, {updated:number, total:number, enabled: boolean, status:string[]}>
      local mutagen = {}

      local function mutagen_status()
        local cwd = vim.uv.cwd() or "."
        mutagen[cwd] = mutagen[cwd]
          or {
            updated = 0,
            total = 0,
            enabled = vim.fs.find("mutagen.yml", { path = cwd, upward = true })[1] ~= nil,
            status = {},
          }
        local now = vim.uv.now() -- timestamp in milliseconds
        local refresh = mutagen[cwd].updated + 10000 < now
        if #mutagen[cwd].status > 0 then
          refresh = mutagen[cwd].updated + 1000 < now
        end
        if mutagen[cwd].enabled and refresh then
          ---@type {name:string, status:string, idle:boolean}[]
          local sessions = {}
          local lines = vim.fn.systemlist("mutagen project list")
          local status = {}
          local name = nil
          for _, line in ipairs(lines) do
            local n = line:match("^Name: (.*)")
            if n then
              name = n
            end
            local s = line:match("^Status: (.*)")
            if s then
              table.insert(sessions, {
                name = name,
                status = s,
                idle = s == "Watching for changes",
              })
            end
          end
          for _, session in ipairs(sessions) do
            if not session.idle then
              table.insert(status, session.name .. ": " .. session.status)
            end
          end
          mutagen[cwd].updated = now
          mutagen[cwd].total = #sessions
          mutagen[cwd].status = status
          if #sessions == 0 then
            vim.notify("Mutagen is not running", vim.log.levels.ERROR, { title = "Mutagen" })
          end
        end
        return mutagen[cwd]
      end

      local error_color = { fg = Snacks.util.color("DiagnosticError") }
      local ok_color = { fg = Snacks.util.color("DiagnosticInfo") }
      table.insert(opts.sections.lualine_x, {
        cond = function()
          return mutagen_status().enabled
        end,
        color = function()
          return (mutagen_status().total == 0 or mutagen_status().status[1]) and error_color or ok_color
        end,
        function()
          local s = mutagen_status()
          local msg = s.total
          if #s.status > 0 then
            msg = msg .. " | " .. table.concat(s.status, " | ")
          end
          return (s.total == 0 and "󰋘 " or "󰋙 ") .. msg
        end,
      })
    end,
  },

  { "akinsho/bufferline.nvim", opts = { options = { separator_style = "slope", show_close_icon = false } } },
  {
    "zenbones-theme/zenbones.nvim",
    dependencies = "rktjmp/lush.nvim",
    lazy = false,
    priority = 1000,
  },
  { "Mofiqul/vscode.nvim" },
}
