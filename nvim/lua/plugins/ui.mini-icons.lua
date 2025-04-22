local Plugin = {
  "echasnovski/mini.icons",
  lazy = true,
  opts = function()
    require("mini.icons").mock_nvim_web_devicons()
    return {
      lsp = {
        supermaven = { glyph = "", hl = "your_hl_group" },
      },
    }
  end,
}

return Plugin
