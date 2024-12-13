return {
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>ue",
        function()
          require("edgy").toggle()
        end,
        desc = "Edgy Toggle",
      },
    -- stylua: ignore
    { "<leader>uE", function() require("edgy").select() end, desc = "Edgy Select Window" },
    },
    opts = function()
      local opts = {
        bottom = {
          {
            ft = "toggleterm",
            size = { height = 0.4 },
            filter = function(buf, win)
              return vim.api.nvim_win_get_config(win).relative == ""
            end,
          },
          {
            ft = "noice",
            size = { height = 0.4 },
            filter = function(buf, win)
              return vim.api.nvim_win_get_config(win).relative == ""
            end,
          },
          "Trouble",
          { ft = "qf", title = "QuickFix" },
          {
            ft = "help",
            size = { height = 20 },
            -- don't open help files in edgy that we're editing
            filter = function(buf)
              return vim.bo[buf].buftype == "help"
            end,
          },
          { title = "Spectre", ft = "spectre_panel", size = { height = 0.4 } },
          { title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
        },
        left = {
          { title = "Neotest Summary", ft = "neotest-summary" },
          -- "neo-tree",
        },
        right = {
          { title = "Grug Far", ft = "grug-far", size = { width = 0.4 } },
        },
        keys = {
          -- increase width
          ["<c-Right>"] = function(win)
            win:resize("width", 2)
          end,
          -- decrease width
          ["<c-Left>"] = function(win)
            win:resize("width", -2)
          end,
          -- increase height
          ["<c-Up>"] = function(win)
            win:resize("height", 2)
          end,
          -- decrease height
          ["<c-Down>"] = function(win)
            win:resize("height", -2)
          end,
        },
      }

      if LazyVim.has("neo-tree.nvim") then
        local pos = {
          filesystem = "left",
          buffers = "top",
          git_status = "right",
          document_symbols = "bottom",
          diagnostics = "bottom",
        }
        local sources = LazyVim.opts("neo-tree.nvim").sources or {}
        for i, v in ipairs(sources) do
          table.insert(opts.left, i, {
            title = "Neo-Tree " .. v:gsub("_", " "):gsub("^%l", string.upper),
            ft = "neo-tree",
            filter = function(buf)
              return vim.b[buf].neo_tree_source == v
            end,
            pinned = true,
            open = function()
              vim.cmd(("Neotree show position=%s %s dir=%s"):format(pos[v] or "bottom", v, LazyVim.root()))
            end,
          })
        end
      end

      -- trouble
      for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
        opts[pos] = opts[pos] or {}
        table.insert(opts[pos], {
          ft = "trouble",
          filter = function(_buf, win)
            return vim.w[win].trouble
              and vim.w[win].trouble.position == pos
              and vim.w[win].trouble.type == "split"
              and vim.w[win].trouble.relative == "editor"
              and not vim.w[win].trouble_preview
          end,
        })
      end

      -- snacks terminal
      for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
        opts[pos] = opts[pos] or {}
        table.insert(opts[pos], {
          ft = "snacks_terminal",
          size = { height = 0.4 },
          title = "%{b:snacks_terminal.id}: %{b:term_title}",
          filter = function(_buf, win)
            return vim.w[win].snacks_win
              and vim.w[win].snacks_win.position == pos
              and vim.w[win].snacks_win.relative == "editor"
              and not vim.w[win].trouble_preview
          end,
        })
      end
      return opts
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    opts = {
      defaults = {
        get_selection_window = function()
          require("edgy").goto_main()
          return 0
        end,
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    optional = true,
    opts = function(_, opts)
      opts.open_files_do_not_replace_types = opts.open_files_do_not_replace_types
        or { "terminal", "Trouble", "qf", "Outline", "trouble" }
      table.insert(opts.open_files_do_not_replace_types, "edgy")
    end,
  },
  {
    "echasnovski/mini.starter",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = "VimEnter",
    opts = function()
      local logo = table.concat({
        "████████╗██╗  ██╗███████╗███╗   ███╗██╗   ██╗██╗   ██╗██╗     ███╗   ██╗",
        "╚══██╔══╝██║  ██║██╔════╝████╗ ████║██║   ██║██║   ██║██║     ████╗  ██║",
        "   ██║   ███████║█████╗  ██╔████╔██║██║   ██║██║   ██║██║     ██╔██╗ ██║",
        "   ██║   ██╔══██║██╔══╝  ██║╚██╔╝██║██║   ██║██║   ██║██║     ██║╚██╗██║",
        "   ██║   ██║  ██║███████╗██║ ╚═╝ ██║╚██████╔╝╚██████╔╝███████╗██║ ╚████║",
        "   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═══╝",
      }, "\n")
      local pad = string.rep(" ", 22)
      local new_section = function(name, action, section)
        return { name = name, action = action, section = pad .. section }
      end

      local starter = require("mini.starter")
    --stylua: ignore
    local config = {
      evaluate_single = true,
      header = logo,
      items = {
        new_section("Find file",       LazyVim.pick(),                        "Telescope"),
        new_section("New file",        "ene | startinsert",                   "Built-in"),
        new_section("Recent files",    LazyVim.pick("oldfiles"),              "Telescope"),
        new_section("Select Session",  "lua require('persistence').select()", "Session"),
        new_section("Find text",       LazyVim.pick("live_grep"),             "Telescope"),
        new_section("Config",          LazyVim.pick.config_files(),           "Config"),
        new_section("Restore session", [[lua require("persistence").load()]], "Session"),
        new_section("Lazy Extras",     "LazyExtras",                          "Config"),
        new_section("Lazy",            "Lazy",                                "Config"),
        new_section("Quit",            "qa",                                  "Built-in"),
      },
      content_hooks = {
        starter.gen_hook.adding_bullet(pad .. "░ ", false),
        starter.gen_hook.aligning("center", "center"),
      },
    }
      return config
    end,
    config = function(_, config)
      -- close Lazy and re-open when starter is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "MiniStarterOpened",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      local starter = require("mini.starter")
      starter.setup(config)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function(ev)
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          local pad_footer = string.rep(" ", 8)
          starter.config.footer = pad_footer .. "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
          -- INFO: based on @echasnovski's recommendation (thanks a lot!!!)
          if vim.bo[ev.buf].filetype == "ministarter" then
            pcall(starter.refresh)
          end
        end,
      })
    end,
  },
  -- {
  --   "sphamba/smear-cursor.nvim",
  --   event = "VeryLazy",
  --   cond = vim.g.neovide == nil,
  --   opts = {
  --     hide_target_hack = true,
  --     cursor_color = "none",
  --   },
  --   specs = {
  --     {
  --       "echasnovski/mini.animate",
  --       optional = true,
  --       opts = {
  --         cursor = { enable = false },
  --       },
  --     },
  --   },
  -- },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },
  { "folke/trouble.nvim", enabled = true },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, {
        function()
          return "💵"
        end,
      })
    end,
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      plugins = {
        gitsigns = true,
        tmux = true,
        kitty = { enabled = false, font = "+2" },
      },
    },
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
  },
  -- colorschemes
  { "ellisonleao/gruvbox.nvim" },
  { "olimorris/onedarkpro.nvim" },
  { "AlexvZyl/nordic.nvim" },
  { "sainnhe/everforest" },
  { "neanias/everforest-nvim" },
  { "navarasu/onedark.nvim" },
  { "marko-cerovac/material.nvim" },
  { "Mofiqul/vscode.nvim" },
  { "sainnhe/sonokai" },
  { "craftzdog/solarized-osaka.nvim" },
  { "rebelot/kanagawa.nvim" },
}
