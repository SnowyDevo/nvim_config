return {
	"Vigemus/iron.nvim",
	config = function()
		local iron = require("iron.core")
		local view = require("iron.view")
		local common = require("iron.fts.common")
		local cfg = {
			scratch_repl = true,
			repl_definition = {
				sh = {
					command = { "zsh" },
				},
				python = {
					command = { "ipython" },
					format = common.bracketed_paste_python,
					block_dividers = { "# %%", "#%%" },
				},
			},

			repl_filetype = function(bufnr, ft)
				return ft
			end,

			repl_open_cmd = view.split.vertical(0.3),
		}

		local keymaps = {
			toggle_repl = "<leader>ir",
			restart_repl = "<leader>iR",
			send_motion = "<leader>sc",
			visual_send = "<leader>sc",
			send_file = "<leader>sf",
			send_line = "<leader>sl",
			send_paragraph = "<leader>sp",
			send_until_cursor = "<leader>su",
			send_mark = "<leader>sm",
			send_code_block = "<leader>sb",
			send_code_block_and_move = "<leader>sn",
			mark_motion = "<leader>mc",
			mark_visual = "<leader>mc",
			remove_mark = "<leader>md",
			cr = "<leader>s<cr>",
			interrupt = "<leader>s<leader>",
			exit = "<leader>sq",
			clear = "<leader>cl",
		}

		local highlight = {
			italic = true,
		}

		local ignore_blank_lines = true

		iron.setup({
			config = cfg,
			keymaps = keymaps,
			highlight = highlight,
			ignore_blank_lines = ignore_blank_lines,
		})

		vim.keymap.set("n", "<leader>if", "<cmd>IronFocus<cr>")
		vim.keymap.set("n", "<leader>ih", "<cmd>IronHide<cr>")
	end,
}
