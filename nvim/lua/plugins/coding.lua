return {

  { "nvim-mini/mini.surround", version = false, opts = { n_lines = 100 } },

  {
    "nvim-mini/mini.move",
    opts = {
      mappings = {
        left = "<A-Left>",
        right = "<A-Right>",
        down = "J",
        up = "K",

        line_left = "<A-Left>",
        line_right = "<A-Right>",
        line_down = "<A-Down>",
        line_up = "<A-Up>",
      },
    },
  },

  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    event = "VeryLazy",
    config = function()
      local mc = require("multicursor-nvim")
      local set = vim.keymap.set

      mc.setup()

      set({ "n", "x" }, "<leader>mj", function()
        mc.lineAddCursor(1)
      end, { desc = "Add cursor below" })
      set({ "n", "x" }, "<leader>mk", function()
        mc.lineAddCursor(-1)
      end, { desc = "Add cursor above" })
      set({ "n", "x" }, "<leader>mn", function()
        mc.matchAddCursor(1)
      end, { desc = "Add next match cursor" })
      set({ "n", "x" }, "<leader>mN", function()
        mc.matchAddCursor(-1)
      end, { desc = "Add previous match cursor" })
      set({ "n", "x" }, "<leader>ms", function()
        mc.matchSkipCursor(1)
      end, { desc = "Skip next match cursor" })
      set({ "n", "x" }, "<leader>mS", function()
        mc.matchSkipCursor(-1)
      end, { desc = "Skip previous match cursor" })
      set({ "n", "x" }, "<C-q>", mc.toggleCursor, { desc = "Toggle cursor" })

      mc.addKeymapLayer(function(layerSet)
        layerSet({ "n", "x" }, "<leader>mx", mc.deleteCursor, { desc = "Delete main cursor" })
        layerSet("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end, { desc = "Clear multicursors" })
      end)
    end,
  },

  {
    "mrjones2014/smart-splits.nvim",
    event = "VeryLazy",
    opts = {
      at_edge = "stop",
      cursor_follows_swapped_bufs = true,
      ignored_buftypes = { "nofile", "prompt", "quickfix" },
      ignored_filetypes = { "help", "qf", "snacks_dashboard", "snacks_notif" },
    },
    keys = {
      {
        "<C-h>",
        function()
          require("smart-splits").move_cursor_left()
        end,
        desc = "Go to left split",
      },
      {
        "<C-j>",
        function()
          require("smart-splits").move_cursor_down()
        end,
        desc = "Go to lower split",
      },
      {
        "<C-k>",
        function()
          require("smart-splits").move_cursor_up()
        end,
        desc = "Go to upper split",
      },
      {
        "<C-l>",
        function()
          require("smart-splits").move_cursor_right()
        end,
        desc = "Go to right split",
      },
      {
        "<C-\\>",
        function()
          require("smart-splits").move_cursor_previous()
        end,
        desc = "Go to previous split",
      },
      {
        "<A-h>",
        function()
          require("smart-splits").resize_left()
        end,
        desc = "Resize split left",
      },
      {
        "<A-j>",
        function()
          require("smart-splits").resize_down()
        end,
        desc = "Resize split down",
      },
      {
        "<A-k>",
        function()
          require("smart-splits").resize_up()
        end,
        desc = "Resize split up",
      },
      {
        "<A-l>",
        function()
          require("smart-splits").resize_right()
        end,
        desc = "Resize split right",
      },
    },
  },
}
