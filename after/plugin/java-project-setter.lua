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
			for _, name in ipairs({ "App.java", "Main.java", "GrahApp.java", "Application.java" }) do
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
		-- STEP 1: Open the target file
		----------------------------------------------------------------------
		vim.defer_fn(function()
			vim.cmd("edit " .. vim.fn.fnameescape(target_file))
		end, 50)

		----------------------------------------------------------------------
		-- STEP 2: Reveal in NeoTree
		----------------------------------------------------------------------
		vim.defer_fn(function()
			local ok, neotree = pcall(require, "neo-tree.command")
			if ok then
				neotree.execute({
					action = "show",
					reveal_file = target_file,
					reveal_force_cwd = true,
				})
			end
		end, 300)

		----------------------------------------------------------------------
		-- STEP 3: Load Java files during idle time (non-blocking)
		----------------------------------------------------------------------
		vim.defer_fn(function()
			local src_dir = cwd .. "/src"
			if vim.fn.isdirectory(src_dir) == 0 then
				return
			end

			-- Start find in background
			vim.system(
				{ "find", src_dir, "-type", "f", "-name", "*.java" },
				{ text = true },
				vim.schedule_wrap(function(proc)
					if not proc.stdout or proc.stdout == "" then
						return
					end

					local files = vim.split(proc.stdout, "\n", { trimempty = true })
					local index = 1
					local total = #files

					-- Load files only during idle moments
					local function load_next_batch()
						if index > total then
							print(string.format("Loaded %d Java files", total))
							return
						end

						-- Load 10 files at a time during idle
						local batch_end = math.min(index + 9, total)

						for i = index, batch_end do
							local file = files[i]
							local abs_path = vim.fn.fnamemodify(file, ":p")
							local bufnr = vim.fn.bufadd(abs_path)

							if bufnr > 0 and vim.api.nvim_buf_is_valid(bufnr) then
								vim.fn.bufload(bufnr)
							end
						end

						index = batch_end + 1

						-- Wait for next idle moment
						vim.defer_fn(load_next_batch, 200)
					end

					-- Start loading after UI is ready
					load_next_batch()
				end)
			)
		end, 1500) -- Start after 1.5 seconds
	end,
})
