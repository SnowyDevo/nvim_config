return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
	opts = {
		focus = true,
	},
	cmd = "Trouble",
	keys = {
		{ "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", desc = "[x]trouble [w]orkspace diagnostics" },
		{
			"<leader>xd",
			"<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
			desc = "open trouble [d]ocument diagnostics",
		},
		{ "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "[x]trouble [q]uickfix list" },
		{ "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "[x]trouble [l]ocation list" },
		{ "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "[x] [t]odos in trouble" },
	},
}
