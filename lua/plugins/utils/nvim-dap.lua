-- Install plugins with lazy.nvim
return {
	-- Core DAP plugin
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			-- UI plugins for better debugging experience
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- Setup DAP UI
			dapui.setup()

			-- Setup virtual text
			require("nvim-dap-virtual-text").setup()

			-- Automatically open/close DAP UI
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Java adapter (for your CPSC 219 project)
			dap.adapters.java = function(callback)
				callback({
					type = "server",
					host = "127.0.0.1",
					port = 5005,
				})
			end

			dap.configurations.java = {
				{
					type = "java",
					request = "attach",
					name = "Debug (Attach) - Remote",
					hostName = "127.0.0.1",
					port = 5005,
				},
			}

			-- Keymaps
			vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
			vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
			vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
			vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
			vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>B", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Debug: Set Conditional Breakpoint" })
			vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Debug: Open REPL" })
			vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Debug: Run Last" })
			vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Debug: Toggle UI" })

			-- Visual mode keymap for evaluating expression
			vim.keymap.set({ "n", "v" }, "<leader>dh", require("dap.ui.widgets").hover, { desc = "Debug: Hover" })
			vim.keymap.set({ "n", "v" }, "<leader>dp", require("dap.ui.widgets").preview, { desc = "Debug: Preview" })
		end,
	},
}
