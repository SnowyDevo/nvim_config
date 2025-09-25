return {
	{
		"jeryldev/pyworks.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{
				"GCBallesteros/jupytext.nvim",
				config = true,
			},
			{
				"benlubas/molten-nvim", -- Required: Code execution
				build = ":UpdateRemotePlugins", -- IMPORTANT: Required for Molten to work
			},
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
				--Conditional for ueberzug or kitty
				image_backend = "kitty", -- or "ueberzug" for other terminals
				-- Optional: Skip auto-configuration of specific dependencies
				-- skip_molten = false,
				-- skip_jupytext = false,
				-- skip_image = false,
				-- skip_keymaps = false,
			})
		end,
	},
}
