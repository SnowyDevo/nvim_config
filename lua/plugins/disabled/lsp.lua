vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",
	callback = function(args)
		local jdtls = require("jdtls")
		local root_dir = require("jdtls.setup").find_root({
			"settings.gradle",
			"settings.gradle.kts",
			"pom.xml",
			"mvnw",
			"gradlew",
			"build.gradle",
			"build.gradle.kts",
			".git",
		})
		local project_name = vim.fn.fnamemodify(root_dir, ":t")
		local workspace_dir = vim.fn.stdpath("data") .. "/site/java/workspace-root/" .. project_name

		local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"

		-- Eclipse JDT.LS installation path
		local jdtls_path = mason_packages .. "/jdtls"

		local config_path = jdtls_path
			.. "/config_"
			.. (vim.loop.os_uname().sysname:match("Linux") and "linux" or "mac")

		-- Java Testing Environment

		-- This bundles definition is the same as in the previous section (java-debug installation)
		local bundles = {
			vim.fn.glob(
				mason_packages .. "java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
				1
			),
		}

		-- This is the new part
		local java_test_bundles = vim.split(vim.fn.glob(mason_packages .. "/java-test/extension/server/*.jar", 1), "\n")
		local excluded = {
			"com.microsoft.java.test.runner-jar-with-dependencies.jar",
			"jacocoagent.jar",
		}
		for _, java_test_jar in ipairs(java_test_bundles) do
			local fname = vim.fn.fnamemodify(java_test_jar, ":t")
			if not vim.tbl_contains(excluded, fname) then
				table.insert(bundles, java_test_jar)
			end
		end

		-- current project found using the root_marker as the dir for project specific data.
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

		local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
		extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

		-- IntelliJ-like keybindings
		local function jdtls_on_attach(client, bufnr)
			jdtls.setup_dap({ hotcodereplace = "auto", bundles = bundles })
			require("jdtls.setup").add_commands()
			require("dap.ext.vscode").load_launchjs()
			require("jdtls.dap").setup_dap_main_class_configs()

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

			-- Build project (like Ctrl+F9 in IntelliJ)
			opts.desc = "Compile: Full"
			vim.keymap.set("n", "<leader>bc", '<Cmd>lua require("jdtls").compile("full")<CR>', opts)

			opts.desc = "Compile: Incremental"
			vim.keymap.set("n", "<leader>bi", '<Cmd>lua require("jdtls").compile("incremental")<CR>', opts)

			-- Update project configuration (like refreshing Gradle/Maven)
			opts.desc = "Update Project Configs"
			vim.keymap.set("n", "<leader>bu", '<Cmd>lua require("jdtls").update_project_config()<CR>', opts)

			opts.desc = "Test Class"
			vim.keymap.set("n", "<leader>tc", jdtls.test_class, opts) -- Test Class

			opts.desc = "Test Method"
			vim.keymap.set("n", "<leader>tm", jdtls.test_nearest_method, opts, { desc = "Test Method" }) -- Test Method
		end

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
				vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar", 1),
				"-configuration",
				config_path,
				"-data",
				workspace_dir,
			},

			root_dir = root_dir,

			capabilities = capabilities,

			settings = {
				java = {
					signatureHelp = { enabled = true },
					contentProvider = { preferred = "fernflower" }, -- Use fernflower to decompile library code
					-- Specify any completion options
					completion = {
						favoriteStaticMembers = {
							"org.hamcrest.MatcherAssert.assertThat",
							"org.hamcrest.Matchers.*",
							"org.hamcrest.CoreMatchers.*",
							"org.junit.jupiter.api.Assertions.*",
							"java.util.Objects.requireNonNull",
							"java.util.Objects.requireNonNullElse",
							"org.mockito.Mockito.*",
						},
						filteredTypes = {
							"com.sun.*",
							"io.micrometer.shaded.*",
							"java.awt.*",
							"jdk.*",
							"sun.*",
						},
					},
					-- Specify any options for organizing imports
					sources = {
						organizeImports = {
							starThreshold = 9999,
							staticStarThreshold = 9999,
						},
					},
					-- How code generation should act
					codeGeneration = {
						toString = {
							template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
						},
						hashCodeEquals = {
							useJava7Objects = true,
						},
						useBlocks = true,
					},
					configuration = {
						runtimes = {
							{
								name = "JavaSE-25",
								path = "/usr/lib/jvm/java-25-openjdk/",
								default = true,
							},
							{
								name = "JavaSE-21",
								path = "/usr/lib/jvm/java-21-openjdk/",
							},
						},
					},
				},
			},

			flags = {
				allow_incremental_sync = true,
			},

			init_options = {
				bundles = bundles,
				extendedClientCapabilities = extendedClientCapabilities,
			},
			on_attach = jdtls_on_attach,
		}

		jdtls.start_or_attach(config)
	end,
})
