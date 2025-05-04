local l = {
  "echasnovski/mini.icons",
  lazy = true,
  opts = function()
    require("mini.icons").mock_nvim_web_devicons()
    return {
      lsp = {
        supermaven = { glyph = "", hl = "supermaven" },
      },
    }
  end,
}

return l
