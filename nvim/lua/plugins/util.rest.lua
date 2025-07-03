return {
  "mistweaverco/kulala.nvim",
  opts = {
    -- possible values: b = buffer, g = global
    environment_scope = "b",
    default_env = "dev",
    vscode_rest_client_environmentvars = false,

    ui = {
      win_opts = {},
      -- default view: "body" or "headers" or "headers_body" or "verbose" or fun(response: Response)
      default_view = "body",
      -- enable winbar
      winbar = true,
      default_winbar_panes = { "body" },
      -- possible values: false, "float"
      show_variable_info_text = false,
      -- icons position: "signcolumn"|"on_request"|"above_request"|"below_request" or nil to disable
      show_icons = "signcolumn",
      icons = {
        inlay = {
          loading = "",
          done = "",
          error = "",
        },
      },
    },

    debug = 0,
  },
}
