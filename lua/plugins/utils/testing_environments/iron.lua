return {
	"Vigemus/iron.nvim",
	ft = "python",
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
			toggle_repl = { "<leader>ir", "[i]ron [t]oggle repl" },
			restart_repl = { "<leader>iR", "[i]ron [r]estart repl" },
			send_motion = { "<leader>sc", "[s]end motion [c]" },
			visual_send = { "<leader>sc", "[s]end motion [c]" },
			send_file = { "<leader>sf", "[s]end [f]ile" },
			send_line = { "<leader>sl", "[s]end [l]ine" },
			send_paragraph = { "<leader>sp", "[s]end [p]aragraph" },
			send_until_cursor = { "<leader>su", "[s]end [u]ntil cursor" },
			send_mark = { "<leader>sm", "[s]end [m]ark" },
			send_code_block = { "<leader>sb", "[s]end code [b]lock" },
			send_code_block_and_move = { "<leader>sn", "[s]end code block [n]' move" },
			mark_motion = { "<leader>mc", "[m]ark motion [c]" },
			mark_visual = { "<leader>mc", "[m]ark motion [c]" },
			remove_mark = { "<leader>md", "[m]ark [d]elete" },
			cr = { "<leader>s<cr>", "[s]end carriage [return]" },
			interrupt = { "<leader>s<leader>", "[leader] interrupt" },
			exit = { "<leader>iq", "[i]ron [q]uit" },
			clear = { "<leader>cl", "[c][l]ear repl" },
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

		vim.keymap.set("n", "<leader>if", "<cmd>IronFocus<cr>", { desc = "[i]ron [f]ocus" })
		vim.keymap.set("n", "<leader>ih", "<cmd>IronHide<cr>", { desc = "[i]ron [h]ide" })
	end,
}
