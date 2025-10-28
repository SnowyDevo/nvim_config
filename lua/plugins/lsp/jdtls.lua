-- Using lazy.nvim
--

return {
	"mfussenegger/nvim-jdtls",
	dependencies = {
		"mfussenegger/nvim-dap", -- Debugging
		"nvim-telescope/telescope.nvim", -- Fuzzy finding
		"nvim-lua/plenary.nvim",
	},
}
