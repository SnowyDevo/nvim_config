return {
	"gbprod/substitute.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local substitute = require("substitute")

		substitute.setup()

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		vim.keymap.set("n", "s", substitute.operator, { desc = "[s]ubstitute with motion" })
		vim.keymap.set("n", "ss", substitute.line, { desc = "[ss]ubstitute line" })
		vim.keymap.set("n", "S", substitute.eol, { desc = "[S]ubstitute to end of line" })
		vim.keymap.set("x", "s", substitute.visual, { desc = "[s]ubstitute in visual mode" })
	end,
}
