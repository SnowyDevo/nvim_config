if vim.g.vscode then
	require("core.options")
	require("core.keymaps")
else
	require("config.lazy")
	require("core.options")
	require("core.keymaps")
	vim.lsp.enable("pyright")
end
