if vim.loader then
	vim.loader.enable()
end

_G.dd = function(...) end
vim.print = _G.dd

require("config.lazy")
