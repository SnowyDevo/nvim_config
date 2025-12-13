-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "exit insert mode with [j] -> [k]" })

-- clear search highlights
keymap.set("n", "<leader>csh", ":nohl<CR>", { desc = "[c]lear [s]earch [h]ighlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "[+] increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "[-] decrement number" }) -- decrement

if not vim.g.vscode then
	--window swapping
	keymap.set("n", "<leader>wh", "<C-w>h", { desc = "focus [w]indow [h] -> left" })
	keymap.set("n", "<leader>wl", "<C-w>l", { desc = "focus [w]indow [l] -> right" })
	keymap.set("n", "<leader>wk", "<C-w>k", { desc = "focus [w]indow [k] -> up" })
	keymap.set("n", "<leader>wj", "<C-w>j", { desc = "focus [w]indow [j] -> down" })
	-- window management
	keymap.set("n", "<leader>sv", "<C-w>v", { desc = "[s]plit window [v]ertically" }) -- split window vertically
	keymap.set("n", "<leader>sh", "<C-w>s", { desc = "[s]plit window [h]orizontally" }) -- split window horizontally
	keymap.set("n", "<leader>se", "<C-w>=", { desc = "[s]plits [e]qual size" }) -- make split windows equal width & height
	keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "[s]plit e[x]it" }) -- close current split window

	keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "[t]ab [o]pen" }) -- open new tab
	keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "[t]ab e[x]it/close" }) -- close current tab
	keymap.set("n", "<leader>tl", "<cmd>tabn<CR>", { desc = "[t]ab [l] -> right (next tab)" }) --  go to next tab
	keymap.set("n", "<leader>th", "<cmd>tabp<CR>", { desc = "[t]ab [h] -> left (prev. tab)" }) --  go to previous tab
	keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "[t]ab open [f]ile to new tab" }) --  move current buffer to new tab

	keymap.set({ "n" }, "<C-k>", function()
		require("lsp_signature").toggle_float_win()
	end, { silent = true, noremap = true, desc = "toggle signature" })

	keymap.set({ "n" }, "<Leader>k", function()
		vim.lsp.buf.signature_help()
	end, { silent = true, noremap = true, desc = "toggle signature" })

	local dap = require("dap")

	vim.keymap.set("n", "<F5>", dap.continue) -- Start/Continue
	vim.keymap.set("n", "<F8>", dap.step_over) -- Step Over
	vim.keymap.set("n", "<F7>", dap.step_into) -- Step Into
	vim.keymap.set("n", "<S-F8>", dap.step_out) -- Step Out
	vim.keymap.set("n", "<F9>", dap.toggle_breakpoint) -- Toggle Breakpoint
end

vim.keymap.set("n", "`wq", "<cmd>wqa!<CR>", { desc = "force close and save all buffers" })
vim.keymap.set("n", "`qq", "<cmd>qa!<CR>", { desc = "force close all buffers" })

vim.keymap.set(
	"n",
	"<leader>cc",
	"<cmd>tabnew ~/.config/nvim/ | e ~/.config/nvim/lua/core/options.lua<CR>",
	{ desc = "open [c]ode[c]onfiguration" }
)

vim.keymap.set("n", "<leader>ccr", "<cmd>source $MYVIMRC<CR>", { desc = "[c]ode [c]onfiguration [r]eset" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
