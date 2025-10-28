local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

local function find_main_class(main_class_name)
	local output_dir = "out/production/" .. project_name

	local main_class_files = vim.fn.globpath(output_dir, "**/" .. main_class_name .. ".class", false, true)

	if #main_class_files > 0 then
		local main_class_path = main_class_files[1]

		local relative_path = main_class_path:gsub("^" .. vim.pesc(output_dir) .. "/", "")

		local fully_qualified = relative_path:gsub("/", "."):gsub("%.class$", "")

		print("Found main class: " .. fully_qualified)

		return fully_qualified
	end
	return main_class_name --fallback
end

local function maven_main_class(main_class_name)
	local output_dir = "target/classes/"

	local main_class_files = vim.fn.globpath(output_dir, "**/" .. main_class_name .. ".class", false, true)

	if #main_class_files > 0 then
		local main_class_path = main_class_files[1]

		local relative_path = main_class_path:gsub("^" .. vim.pesc(output_dir) .. "/", "")

		local fully_qualified = relative_path:gsub("/", "."):gsub("%.class$", "")

		print("Found main class: " .. fully_qualified)

		return fully_qualified
	end
	return main_class_name --fallback
end

return {
	"CRAG666/code_runner.nvim",
	config = function()
		require("code_runner").setup({
			filetype = {
				java = {
					[[javac -d "out/production/$(basename $PWD)" $(find src -name "*.java" -not -path "src/test/*") &&]],
					[[java -cp "out/production/]]
						.. project_name
						.. [[:src/main/resources:lib/*" ]]
						.. find_main_class("Main"),
				}, -- IntelliJ-like
				-- java = {
				-- 	[[java -cp "target/classes:~/.m2/repository/" ]] .. maven_main_class("Main"),
				-- }, -- Maven-like
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
