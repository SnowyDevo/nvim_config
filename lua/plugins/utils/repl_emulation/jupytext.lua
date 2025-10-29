return {
	"GCBallesteros/jupytext.nvim",
	cond = function()
		return vim.fn.glob("pyproject.toml") ~= "" or vim.fn.glob("requirements.txt") ~= ""
	end,
	config = function()
		require("jupytext").setup({
			style = "hydrogen",
			output_extension = "auto", -- Default extension. Don't change unless you know what you are doing
			force_ft = nil, -- Default filetype. Don't change unless you know what you are doing
			custom_language_formatting = {},
		})
	end,
}
