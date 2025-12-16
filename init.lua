if not vim.g.vscode then
	require("config.lazy")
	vim.lsp.enable("pyright")
end
require("core.options")
require("core.keymaps")
