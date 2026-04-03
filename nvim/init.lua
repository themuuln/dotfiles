if vim.env.VSCODE then
  vim.g.vscode = true
end

require("config.lazy")
require("config.flutter_remote").setup()
