return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"mfussenegger/nvim-jdtls",
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dap, dapui = require("dap"), require("dapui")
		dap.listeners.before.attach.dapui_config = function()
			dapui.open({ reset = true })
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open({ reset = true })
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.open({ reset = true })
			require("custom-functions")
			if file_exists(vim.g.LAST_EXECUTED_FILE) and vim.g.DELETE_LAST_EXECUTED_FILE then
				vim.cmd("silent!!{ rm -f " .. vim.g.LAST_EXECUTED_FILE .. "; } >/dev/null 2>&1")
			end
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.open({ reset = true })
			require("custom-functions")
			if file_exists(vim.g.LAST_EXECUTED_FILE) and vim.g.DELETE_LAST_EXECUTED_FILE then
				vim.cmd("silent!!{ rm -f " .. vim.g.LAST_EXECUTED_FILE .. "; } >/dev/null 2>&1")
			end
		end
		dap.adapters.codelldb = {
			type = "executable",
			command = "codelldb", -- or if not in $PATH: "/absolute/path/to/codelldb"
			-- On windows you may have to uncomment this:
			-- detached = false,
		}
		dap.configurations.cpp = {
			{
				name = "Launch file",
				type = "codelldb",
				request = "launch",
				program = function()
					require("custom-functions")
					if vim.g.CPP_PROJECT then
						if file_exists("main") then
							vim.cmd("silent!!{ rm -f main; } >/dev/null 2>&1")
						end
						vim.cmd("silent!!{ clang++-19 -pedantic-errors -g -O0 *.cpp -o main; } >/dev/null 2>&1")
						if file_exists("main") then
							vim.g.LAST_EXECUTED_FILE = "main"
							return vim.g.LAST_EXECUTED_FILE
						else
							return nil
						end
					else
						-- local file = vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
						local file = vim.api.nvim_buf_get_name(0)
						if file_exists(vim.fn.fnamemodify(file, ":r")) then
							vim.cmd("silent!!{ rm -f " .. vim.fn.fnamemodify(file, ":r") .. "; } >/dev/null 2>&1")
						end
						vim.cmd(
							"silent!!{ clang++-19 -pedantic-errors -g -O0 "
								.. file
								.. " -o "
								.. vim.fn.fnamemodify(file, ":r")
								.. "; } >/dev/null 2>&1"
						)
						if file_exists(vim.fn.fnamemodify(file, ":r")) then
							vim.g.LAST_EXECUTED_FILE = vim.fn.fnamemodify(file, ":r")
							return vim.g.LAST_EXECUTED_FILE
						else
							return nil
						end
					end
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
			},
		}
		dap.configurations.c = dap.configurations.cpp
		dap.configurations.java = {
			{
				javaExec = "java",
				request = "launch",
				type = "java",
			},
		}
		dapui.setup({
			expand_lines = true,
			layouts = {
				{
					-- You can change the order of elements in the sidebar
					elements = {
						-- Provide IDs as strings or tables with "id" and "size" keys
						{
							id = "scopes",
							size = 0.25, -- Can be float or integer > 1
						},
						{ id = "breakpoints", size = 0.25 },
						{ id = "stacks", size = 0.25 },
						{ id = "watches", size = 0.25 },
					},
					size = 40,
					position = "right", -- Can be "left" or "right"
				},
				{
					elements = {
						"repl",
						"console",
					},
					size = 10,
					position = "bottom", -- Can be "bottom" or "top"
				},
			},
		})
		vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "[d]ebugger toggle [b]reakpoint" })
		vim.keymap.set("n", "<leader>dl", dap.continue, { desc = "[d]ebugger [l]aunch" })
		vim.keymap.set("n", "<leader>dr", dap.restart, { desc = "[d]ebugger [r]estart" })
		vim.keymap.set("n", "<leader>ddc", dap.run_to_cursor, { desc = "[d]ebugger in [d]ebug run to [c]ursor" })
		vim.keymap.set("n", "<leader>ddt", dap.terminate, { desc = "[d]ebugger in [d]ebug [t]erminate" })
		vim.keymap.set("n", "<leader>ddi", dap.step_into, { desc = "[d]ebugger in [d]ebug step [i]nto" })
		vim.keymap.set("n", "<leader>ddv", dap.step_over, { desc = "[d]ebugger in [d]ebug step o[v]er" })
		vim.keymap.set("n", "<leader>ddo", dap.step_out, { desc = "[d]ebugger in [d]ebug step [o]ut" })
		vim.keymap.set("n", "<leader>ddb", dap.step_back, { desc = "[d]ebugger in [d]ebug step [b]ack" })
		vim.keymap.set(
			"n",
			"<leader>dt",
			"<cmd>lua require('dapui').toggle({ reset = true })<CR>",
			{ desc = "[d]ebugger [t]oggle UI GOTO" }
		)
	end,
}
