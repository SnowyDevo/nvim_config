-- plugins/lsp/javalsp.lua
return {
	"mfussenegger/nvim-jdtls",
	ft = "java",
	config = function()
		local jdtls = require("jdtls")
		local jdtls_bin_path = vim.fn.stdpath("data") .. "/mason/bin/jdtls"

		-- Find the project root based on common Java build files
		local root_dir = jdtls.setup.find_root({ "pom.xml", "build.gradle", ".git" })

		-- Set a dedicated workspace directory to avoid re-indexing on every startup
		local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
		local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. project_name

		-- Command to start the language server. We use the Mason-installed wrapper.
		local java_cmd = {
			jdtls_bin_path,
			"-data",
			workspace_dir,
		}

		-- Configuration passed to jdtls
		local config = {
			cmd = java_cmd,
			root_dir = root_dir,
			on_attach = function(client, bufnr)
				-- Set up keymaps and other behaviors after the server attaches
				require("jdtls").setup.add_commands()
				require("jdtls.dap").setup_dap_main_class_configs()

				-- You can define your own keymaps here
				-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
			end,
			settings = {
				java = {
					format = {
						enabled = true,
					},
					maven = {
						downloadSources = true,
					},
				},
			},
		}

		-- Launch the server when opening a Java file
		jdtls.start_or_attach(config)
	end,
}
