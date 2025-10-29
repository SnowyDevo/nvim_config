return {
	{
		"jeryldev/pyworks.nvim",
		lazy = false,
		priority = 100,
		dependencies = {
			"GCBallesteros/jupytext.nvim",
			"benlubas/molten-nvim", -- Required: Code execution
			"3rd/image.nvim", -- Required: Image display
		},
		config = function()
			require("pyworks").setup({
				silent = true,
				-- Just specify any preferences:
				python = {
					use_uv = true, -- Use uv for faster package installation
					preferred_venv_name = ".venv",
					auto_install_essentials = true,
					essentials = { "pynvim", "ipykernel", "jupyter_client", "jupytext" },
				},
				-- Conditional for ueberzug or kitty
				-- image_backend = "ueberzug",
				image_backend = "kitty", -- or "ueberzug" for other terminals
				-- Optional: Skip auto-configuration of specific dependencies
				-- skip_molten = false,
				-- skip_jupytext = false,
				-- skip_image = false,
				-- skip_keymaps = false,
				notifications = {
					verbose_first_time = false,
					silent_when_ready = false,
					show_progress = false,
					debug_mode = false,
				},
			})
		end,
	},
}
