local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

return {
	"CRAG666/code_runner.nvim",
	config = function()
		require("code_runner").setup({
			filetype = {
				java = {
					[[java -cp "out/production/]] .. project_name .. [[" Main]],
				},
				python = "python3 -u",
				typescript = "deno run",
				rust = {
					"cd $dir &&",
					"rustc $fileName &&",
					"$dir/$fileNameWithoutExt",
				},
			},
		})
	end,
	vim.keymap.set("n", "<leader>rr", ":RunCode<CR>", { noremap = true, silent = false }),
	vim.keymap.set("n", "<leader>rf", ":RunFile<CR>", { noremap = true, silent = false }),
	vim.keymap.set("n", "<leader>rft", ":RunFile tab<CR>", { noremap = true, silent = false }),
	vim.keymap.set("n", "<leader>rp", ":RunProject<CR>", { noremap = true, silent = false }),
	vim.keymap.set("n", "<leader>rc", ":RunClose<CR>", { noremap = true, silent = false }),
	vim.keymap.set("n", "<leader>crf", ":CRFiletype<CR>", { noremap = true, silent = false }),
	vim.keymap.set("n", "<leader>crp", ":CRProjects<CR>", { noremap = true, silent = false }),
}
