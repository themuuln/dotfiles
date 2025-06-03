return {
  -- {
  --   "Exafunction/windsurf.vim",
  --   event = "BufEnter",
  -- },
  {
    "monkoose/neocodeium",
    event = "VeryLazy",
    dependencies = {
      "saghen/blink.cmp", -- Ensure blink.cmp is loaded
    },
    config = function()
      local neocodeium = require("neocodeium")
      local blink = require("blink.cmp")

      -- Configure neocodeium
      neocodeium.setup({
        manual = false, -- Automatic suggestions
        silent = true, -- Avoid noisy messages
        debounce = false, -- Show suggestions while typing
        filetypes = {
          TelescopePrompt = false,
          ["dap-repl"] = false,
        },
        filter = function(bufnr)
          -- Disable neocodeium when blink.cmp menu is visible
          return not blink.is_visible()
        end,
      })

      -- Autocommand to clear neocodeium when blink.cmp menu opens
      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuOpen",
        callback = function()
          neocodeium.clear()
        end,
      })

      -- Keymaps matching neocodeium defaults, with <Tab> for accept
      vim.keymap.set("i", "<Tab>", function()
        if neocodeium.visible() then
          neocodeium.accept()
        else
          return vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
        end
      end, { expr = true, desc = "Accept NeoCodeium suggestion or insert tab" })
      vim.keymap.set("i", "<C-f>", function()
        neocodeium.accept_word()
      end, { desc = "Accept NeoCodeium word" })
      vim.keymap.set("i", "<C-e>", function()
        neocodeium.accept_line()
      end, { desc = "Accept NeoCodeium line" })
      vim.keymap.set("i", "<C-j>", function()
        neocodeium.cycle(1)
      end, { desc = "Cycle to next NeoCodeium suggestion" })
      vim.keymap.set("i", "<C-k>", function()
        neocodeium.cycle(-1)
      end, { desc = "Cycle to previous NeoCodeium suggestion" })
      vim.keymap.set("i", "<C-x>", neocodeium.clear, { desc = "Clear NeoCodeium suggestion" })
    end,
  },
}
