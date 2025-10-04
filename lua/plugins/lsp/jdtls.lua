-- Using lazy.nvim
return {
	"mfussenegger/nvim-jdtls",
	dependencies = {
		"mfussenegger/nvim-dap", -- Debugging
		"nvim-telescope/telescope.nvim", -- Fuzzy finding
		"nvim-lua/plenary.nvim",
	},
	ft = "java",
	config = function()
		local jdtls = require("jdtls")
		local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
		local workspace_dir = vim.fn.stdpath("data") .. "/site/java/workspace-root/" .. project_name

		-- Eclipse JDT.LS installation path
		local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
		local config_path = jdtls_path .. "/config_linux" -- or config_mac, config_win

		local config = {
			cmd = {
				"java",
				"-Declipse.application=org.eclipse.jdt.ls.core.id1",
				"-Dosgi.bundles.defaultStartLevel=4",
				"-Declipse.product=org.eclipse.jdt.ls.core.product",
				"-Dlog.protocol=true",
				"-Dlog.level=ALL",
				"-Xmx1g",
				"--add-modules=ALL-SYSTEM",
				"--add-opens",
				"java.base/java.util=ALL-UNNAMED",
				"--add-opens",
				"java.base/java.lang=ALL-UNNAMED",
				"-jar",
				vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
				"-configuration",
				config_path,
				"-data",
				workspace_dir,
			},

			root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),

			settings = {
				java = {},
			},

			flags = {
				allow_incremental_sync = true,
			},

			init_options = {
				bundles = {},
			},
		}

		-- IntelliJ-like keybindings
		local function jdtls_on_attach(client, bufnr)
			jdtls.setup_dap({ hotcodereplace = "auto" })

			local opts = { noremap = true, silent = true, buffer = bufnr }

			-- IntelliJ-inspired mappings
			opts.desc = "Optimize Imports"
			vim.keymap.set("n", "<leader>oi", jdtls.organize_imports, opts)

			opts.desc = "Refactor: Extract Variable"
			vim.keymap.set("n", "<leader>rv", jdtls.extract_variable, opts)
			vim.keymap.set("v", "<leader>rv", [[<ESC><CMD>lua require('jdtls').extract_variable(true)<CR>]], opts)

			opts.desc = "Refactor: Extract Constant"
			vim.keymap.set("n", "<leader>rc", jdtls.extract_constant, opts)
			vim.keymap.set("v", "<leader>rc", [[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]], opts)

			opts.desc = "Refactor: Extract Method"
			vim.keymap.set("v", "<leader>rm", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], opts)

			opts.desc = "Test Class"
			vim.keymap.set("n", "<leader>tc", jdtls.test_class, opts) -- Test Class
			-- Build project (like Ctrl+F9 in IntelliJ)
			opts.desc = "Compile: Full"
			vim.keymap.set("n", "<leader>bc", '<Cmd>lua require("jdtls").compile("full")<CR>', opts)

			opts.desc = "Compile: Incremental"
			vim.keymap.set("n", "<leader>bi", '<Cmd>lua require("jdtls").compile("incremental")<CR>', opts)

			-- Update project configuration (like refreshing Gradle/Maven)
			opts.desc = "Update Project Configs"
			vim.keymap.set("n", "<leader>bu", '<Cmd>lua require("jdtls").update_project_config()<CR>', opts)

			-- Build and run main class
			opts.desc = "Compile and Run"
			vim.keymap.set("n", "<F5>", '<Cmd>lua require("jdtls").test_class()<CR>', opts)

			opts.desc = "Test Method"
			vim.keymap.set("n", "<leader>tm", jdtls.test_nearest_method, opts, { desc = "Test Method" }) -- Test Method
		end

		config.on_attach = jdtls_on_attach

		jdtls.start_or_attach(config)
	end,
}
