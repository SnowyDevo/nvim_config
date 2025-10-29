return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns

			local function map(mode, l, r, desc)
				vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
			end

			-- Navigation
			map("n", "]h", gs.next_hunk, "Next Hunk")
			map("n", "[h", gs.prev_hunk, "Prev Hunk")

			-- Actions
			map("n", "<leader>hs", gs.stage_hunk, "[h]unk [s]tage")
			map("n", "<leader>hr", gs.reset_hunk, "[h]unk [r]reset")
			map("v", "<leader>hs", function()
				gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "[h]unk [s]tage")
			map("v", "<leader>hr", function()
				gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "[h]unk [r]reset")

			map("n", "<leader>hS", gs.stage_buffer, "[h] [S]tage buffer")
			map("n", "<leader>hR", gs.reset_buffer, "[h] [R]eset buffer")

			map("n", "<leader>hu", gs.undo_stage_hunk, "[h]unk [u]ndo stage")

			map("n", "<leader>hp", gs.preview_hunk, "[h]unk [p]review")

			map("n", "<leader>hb", function()
				gs.blame_line({ full = true })
			end, "[h] [b]lame line")
			map("n", "<leader>hB", gs.toggle_current_line_blame, "[h] [B]lame line toggle")

			map("n", "<leader>hd", gs.diffthis, "[h] [d]iff this")
			map("n", "<leader>hD", function()
				gs.diffthis("~")
			end, "[h] [d]iff this ~")

			-- Text object
			map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "g[i]tsigns [h]unk select ")
		end,
	},
}
