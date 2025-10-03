return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui", -- optional UI
		"theHamsta/nvim-dap-virtual-text", -- inline variable display
	},
	config = function()
		require("dapui").setup()
		require("nvim-dap-virtual-text").setup()
	end,
}
