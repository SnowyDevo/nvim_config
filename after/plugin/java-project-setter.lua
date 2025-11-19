local function scope_root_project()
	-- Prefer current buffer directory; fallback to cwd
	local buf_dir = vim.fn.expand("%:p:h")
	if buf_dir == "" then
		buf_dir = vim.fn.getcwd()
	end

	local indicators = {
		"gradlew",
		"mvnw",
		"pom.xml",
		".classpath",
	}

	for _, file in ipairs(indicators) do
		if vim.fn.filereadable(buf_dir .. "/" .. file) == 1 then
			return true
		end
	end

	return false
end

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local opened_with_dot = vim.fn.argc() == 1 and vim.fn.argv(0) == "."

		if not (opened_with_dot and scope_root_project()) then
			return
		end

		local preferred_files = {
			"src/main/java/App.java",
			"src/App.java",
			"App.java",
			"src/main/java/Main.java",
			"src/Main.java",
			"Main.java",
		}

		local cwd = vim.fn.getcwd()
		local target_file = nil

		-- Direct path search
		for _, rel in ipairs(preferred_files) do
			local full = cwd .. "/" .. rel
			if vim.fn.filereadable(full) == 1 then
				target_file = full
				break
			end
		end

		-- Recursive fallback
		if not target_file then
			for _, name in ipairs({ "App.java", "Main.java" }) do
				local found = vim.fn.findfile(name, cwd .. "/**")
				if found ~= "" then
					target_file = vim.fn.fnamemodify(found, ":p")
					break
				end
			end
		end

		if not target_file then
			return
		end

		----------------------------------------------------------------------
		-- STEP 1: Open the target file (App.java/Main.java)
		----------------------------------------------------------------------
		vim.defer_fn(function()
			vim.cmd("edit " .. vim.fn.fnameescape(target_file))
		end, 50)

		----------------------------------------------------------------------
		-- STEP 2: Load all Java files in background (async)
		----------------------------------------------------------------------
		vim.system({ "find", "src", "-type", "f", "-name", "*.java" }, { text = true }, function(proc)
			local out = proc.stdout
			if not out or out == "" then
				return
			end

			local files = vim.split(out, "\n", { trimempty = true })

			for _, file in ipairs(files) do
				vim.schedule(function()
					vim.cmd("badd " .. file)
					local bufnr = vim.fn.bufnr(file)
					if bufnr > 0 then
						vim.fn.bufload(bufnr)
					end
				end)
			end
		end)

		----------------------------------------------------------------------
		-- STEP 3: Reveal in NeoTree
		----------------------------------------------------------------------
		vim.defer_fn(function()
			require("neo-tree.command").execute({
				action = "show",
				reveal_file = target_file,
				reveal_force_cwd = true,
			})
		end, 250)
	end,
})
