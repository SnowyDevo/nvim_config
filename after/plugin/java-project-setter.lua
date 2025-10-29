local function scope_root_project()
	-- Get the directory of the current buffer
	local buf_dir = vim.fn.expand("%:p:h")

	-- If no buffer yet, use current working directory
	if buf_dir == "" then
		buf_dir = vim.fn.getcwd()
	end

	local indicators = {
		"gradlew",
		"mvnw",
		"pom.xml",
		".classpath",
	}

	-- Check file indicators in buffer's directory
	for _, indicator in ipairs(indicators) do
		local path = buf_dir .. "/" .. indicator
		if vim.fn.filereadable(path) == 1 then
			return true
		end
	end

	return false
end

-- Auto-navigate to App.java or Main.java in NeoTree when opening with `nvim .`
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local opened_with_dot = vim.fn.argc() == 1 and vim.fn.argv(0) == "."

		if opened_with_dot and scope_root_project() then
			-- Preferred order: App.java first, then Main.java
			local preferred_files = {
				"src/main/java/App.java",
				"src/App.java",
				"App.java",
				"src/main/java/Main.java",
				"src/Main.java",
				"Main.java",
			}

			local target_file = nil
			for _, location in ipairs(preferred_files) do
				local full_path = vim.fn.getcwd() .. "/" .. location
				if vim.fn.filereadable(full_path) == 1 then
					target_file = full_path
					break
				end
			end

			-- Fallback: search recursively for App.java first, then Main.java
			if not target_file then
				for _, name in ipairs({ "App.java", "Main.java" }) do
					local found = vim.fn.findfile(name, vim.fn.getcwd() .. "/**")
					if found ~= "" then
						target_file = vim.fn.fnamemodify(found, ":p")
						break
					end
				end
			end

			-- Reveal in NeoTree
			if target_file then
				vim.defer_fn(function()
					vim.cmd("edit " .. vim.fn.fnameescape(target_file))
					vim.defer_fn(function()
						require("neo-tree.command").execute({
							action = "show",
							reveal_file = target_file,
							reveal_force_cwd = true,
						})
					end, 100)
				end, 200)
			end
		end
	end,
})
