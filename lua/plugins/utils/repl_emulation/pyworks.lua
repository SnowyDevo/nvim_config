return {
	{
		"jeryldev/pyworks.nvim",
		dependencies = {
			{
				"GCBallesteros/jupytext.nvim",
				config = function() -- IMPORTANT: This ensures jupytext.setup() is called!
					require("jupytext").setup({
						style = "percent",
						output_extension = "auto", -- Default extension. Don't change unless you know what you are doing
						force_ft = nil, -- Default filetype. Don't change unless you know what you are doing
						custom_language_formatting = {},
					})
				end,
			},
			{
				"benlubas/molten-nvim", -- Required: Code execution
				build = ":UpdateRemotePlugins", -- IMPORTANT: Required for Molten to work
			},
			"3rd/image.nvim", -- Required: Image display
		},
		ft = { "python", "jupyter" },
		event = { "BufReadPre *.py", "BufReadPre *.ipynb" },
		config = function()
			require("pyworks").setup({
				-- Pyworks auto-configures everything with proven settings!
				-- Just specify any preferences:
				python = {
					use_uv = true, -- Use uv for faster package installation
					preferred_venv_name = ".venv",
					auto_install_essentials = true,
					essentials = { "pynvim", "ipykernel", "jupyter_client", "jupytext" },
				},

				--Conditional for ueberzug or kitty
				image_backend = "kitty", -- or "ueberzug" for other terminals

				on_notebook_open = function(bufnr)
					vim.defer_fn(function()
						vim.api.nvim_buf_call(bufnr, function()
							vim.cmd("LspRestart")
						end)
					end, 500)
				end,
				-- Optional: Skip auto-configuration of specific dependencies
				-- skip_molten = false,
				-- skip_jupytext = false,
				-- skip_image = false,
				-- skip_keymaps = false,
			})
		end,
		lazy = false, -- Load immediately for file detection
		priority = 100, -- Load early
	},
}
