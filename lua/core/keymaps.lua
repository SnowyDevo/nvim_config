-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement
--window swapping
keymap.set("n", "<leader>wh", "<C-w>h", { desc = "Focus left" })
keymap.set("n", "<leader>wl", "<C-w>l", { desc = "Focus right" })
keymap.set("n", "<leader>wk", "<C-w>k", { desc = "Focus up" })
keymap.set("n", "<leader>wj", "<C-w>j", { desc = "Focus down" })
-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

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
