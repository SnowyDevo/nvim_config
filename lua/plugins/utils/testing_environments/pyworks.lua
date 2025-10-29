local image_backend = vim.env.TERM == "xterm-kitty" and "kitty" or "ueberzug"

local function scope_root_project()
	-- Get the directory of the current buffer
	local buf_dir = vim.fn.expand("%:p:h")

	-- If no buffer yet, use current working directory
	if buf_dir == "" then
		buf_dir = vim.fn.getcwd()
	end

	local indicators = {
		"pyproject.toml",
		"requirements.txt",
		"setup.py",
		"setup.cfg",
	}

	-- Check file indicators in buffer's directory
	for _, indicator in ipairs(indicators) do
		local path = buf_dir .. "/" .. indicator
		if vim.fn.filereadable(path) == 1 then
			return true
		end
	end

	-- Check directory indicators
	if vim.fn.isdirectory(buf_dir .. "/.venv") == 1 then
		return true
	end
	if vim.fn.isdirectory(buf_dir .. "/venv") == 1 then
		return true
	end

	-- Check for .py files in buffer's directory
	local py_files = vim.fn.glob(buf_dir .. "/*.py", false, true)
	if #py_files > 0 then
		return true
	end

	return false
end

return {
	{
		"jeryldev/pyworks.nvim",
		priority = 100,
		cond = scope_root_project(),
		dependencies = {
			"GCBallesteros/jupytext.nvim",
			"benlubas/molten-nvim", -- Required: Code execution
			"3rd/image.nvim", -- Required: Image display
		},
		config = function()
			require("pyworks").setup({
				-- Just specify any preferences:
				python = {
					use_uv = true, -- Use uv for faster package installation
					preferred_venv_name = ".venv",
					auto_install_essentials = true,
					essentials = { "pynvim", "ipykernel", "jupyter_client", "jupytext" },
				},
				-- Conditional for ueberzug or kitty
				-- image_backend = "ueberzug",
				image_backend = image_backend, -- or "ueberzug" for other terminals
				-- Optional: Skip auto-configuration of specific dependencies
				-- skip_molten = false,
				-- skip_jupytext = false,
				-- skip_image = false,
				-- skip_keymaps = false,
				notifications = {
					verbose_first_time = true,
					silent_when_ready = true,
					show_progress = false,
					debug_mode = false,
				},
			})
		end,
	},
	{
		"GCBallesteros/jupytext.nvim",
		cond = scope_root_project(),
		config = function()
			require("jupytext").setup({
				style = "hydrogen",
				output_extension = "auto", -- Default extension. Don't change unless you know what you are doing
				force_ft = nil, -- Default filetype. Don't change unless you know what you are doing
				custom_language_formatting = {},
			})
		end,
	},
	{
		"benlubas/molten-nvim",
		version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
		dependencies = { "3rd/image.nvim" },
		build = ":UpdateRemotePlugins",
		init = function()
			-- these are examples, not defaults. Please see the readme
			vim.g.molten_image_provider = "image.nvim"
			vim.g.molten_output_win_max_height = 20
		end,
	},
	{
		-- see the image.nvim readme for more information about configuring this plugin
		"3rd/image.nvim",
		opts = {
			-- backend = "ueberzug",
			backend = image_backend, -- or "ueberzug" for other terminals
			max_width = 100,
			max_height = 12,
			max_height_window_percentage = math.huge,
			max_width_window_percentage = math.huge,
			window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
			window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
		},
	},
}
