return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {},
		config = function()
			require("mason-lspconfig").setup({
				automatic_enable = {
					exclude = {
						"jdtls",
					},
				},
				ensure_installed = {
					"html",
					"cssls",
					"tailwindcss",
					"svelte",
					"lua_ls",
					"graphql",
					"emmet_ls",
					"prismals",
					"ruff",
					"jdtls",
					"lemminx",
					"fortls",
				},
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"glow",
					"lua-language-server",
					"marksman",
					"prettier",
					"rust-analyzer",
					"shellcheck",
					"stylua",
					"zls",
					"isort",
					"black",
					"java-test",
					"java-debug-adapter",
					"google-java-format",
					"checkstyle",
					"fprettify",
					"fortitude",
				},
			})
		end,
	},
}
