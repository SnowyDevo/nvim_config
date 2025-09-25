return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPre", "BufNewFile" },
	lazy = false,
	main = "ibl",
	opts = {
		indent = { char = "┊" },
	},
}
