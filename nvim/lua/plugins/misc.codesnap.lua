return {
  {
    "mistricky/codesnap.nvim",
    build = "make",
    config = function(_, opts)
      local codesnap_opts = vim.tbl_deep_extend("force", opts or {}, {
        title = "",
        watermark = "",
        mac_window_bar = true,
        breadcrumbs_separator = "/",
        has_breadcrumbs = true,
        has_line_number = true,
        show_workspace = true,
        bg_color = "#9FB3E7",
      })
      require("codesnap").setup(codesnap_opts)

      -- Or map it directly to a keybinding (example using visual mode)
      -- vim.keymap.set("v", "<leader>cs", ":Codesnap<CR>", { desc = "Create codesnap" })
    end,
  },
}
