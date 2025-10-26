return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	lazy = false,
	config = function()
		local neotree = require("neo-tree")
		local highlights = require("neo-tree.ui.highlights")
		-- Open using OS default browser
		neotree.setup({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.INFO] = "",
					[vim.diagnostic.severity.HINT] = "󰌵",
				},
			},
			default_component_configs = {
				indent = {
					with_expanders = true,
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
			},
			event_handlers = {
				{
					event = "neo_tree_buffer_enter",
					handler = function()
						-- This effectively hides the cursor
						vim.cmd("highlight! Cursor blend=100")
					end,
				},
				{
					event = "neo_tree_buffer_leave",
					handler = function()
						-- Make this whatever your current Cursor highlight group is.
						vim.cmd("highlight! Cursor guibg=#5f87af blend=0")
					end,
				},
			},
			filesystem = {
				group_empty_dirs = true,
				window = {
					mappings = {
						["o"] = "system_open",
						["<tab>"] = function(state)
							state.commands["open"](state)
							vim.cmd("Neotree reveal")
						end,
					},
					renderers = {
						directory = {
							{
								"indent",
								with_markers = true,
								indent_marker = "│",
								last_indent_marker = "└",
								indent_size = 2,
							},
							-- other components
						},
						file = {
							{
								"indent",
								with_markers = true,
								indent_marker = "│",
								last_indent_marker = "└",
								indent_size = 2,
							},
						},
					},
				},
				components = {
					icon = function(config, node, state)
						local icon = config.default or " "
						local padding = config.padding or " "
						local highlight = config.highlight or highlights.FILE_ICON

						if node.type == "directory" then
							highlight = highlights.DIRECTORY_ICON
							if node:is_expanded() then
								icon = config.folder_open or ""
							else
								icon = config.folder_closed or ""
							end
						elseif node.type == "file" then
							local success, web_devicons = pcall(require, "nvim-web-devicons")
							if success then
								local devicon, hl = web_devicons.get_icon(node.name, node.ext)
								icon = devicon or icon
								highlight = hl or highlight
							end
						end

						return {
							text = icon .. padding,
							highlight = highlight,
						}
					end,
				},
			},
			commands = {
				system_open = function(state)
					local node = state.tree:get_node()
					local path = node:get_id()
					-- Linux: open file in default application
					vim.fn.jobstart({ "dolphin", path }, { detach = true })

					-- Windows: Without removing the file from the path, it opens in code.exe instead of explorer.exe
					local p
					local lastSlashIndex = path:match("^.+()\\[^\\]*$") -- Match the last slash and everything before it
					if lastSlashIndex then
						p = path:sub(1, lastSlashIndex - 1) -- Extract substring before the last slash
					else
						p = path -- If no slash found, return original path
					end
					vim.cmd("silent !start explorer " .. p)
				end,
			},
		})

		local keymap = vim.keymap

		keymap.set("n", "<leader>ee", "<cmd>Neotree left toggle<CR>", { desc = "Toggle file explorer" })
		keymap.set("n", "<leader>ew", "<cmd>Neotree float<CR>", { desc = "Open floating file explorer explorer" })
		keymap.set("n", "<leader>eb", "<cmd>Neotree focus buffers left<CR>", { desc = "Focus buffer list" })
		keymap.set("n", "<leader>eg", "<cmd>Neotree focus git_status left<CR>", { desc = "Focus Git Status" })
		keymap.set("n", "<leader>ef", "<cmd>Neotree <CR>", { desc = "Open file explorer on file" })
	end,
}
