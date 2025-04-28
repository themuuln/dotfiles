return {
  {
    "folke/noice.nvim",
    opts = function(_, opts)
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
-- return {
--   {
--     "folke/noice.nvim",
--     opts = {
--       notify = {
--         enabled = false, -- disables Noice's notification handler
--       },
--       lsp = {
--         hover = {
--           enabled = false, -- disables Noice's hover handler
--         },
--         signature = {
--           enabled = false, -- disables Noice's signature help handler
--         },
--         override = {
--           ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
--           ["vim.lsp.util.stylize_markdown"] = false,
--         },
--       },
--     },
--   },
-- }
