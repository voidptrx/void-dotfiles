local map = vim.keymap

--------------------------------------------------------------------------------
-- ◢◤ CORE NAVIGATION & MOVEMENT ◢◤
--------------------------------------------------------------------------------
map.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map.set({ "n", "x" }, "}", "}", { desc = "Next Paragraph" })
map.set({ "n", "x" }, "{", "{", { desc = "Prev Paragraph" })
map.set("n", "<left>", '<cmd>echo "[USE H!!]"<CR>')
map.set("n", "<right>", '<cmd>echo "[USE L!!]"<CR>')
map.set("n", "<up>", '<cmd>echo "[USE K!!]"<CR>')
map.set("n", "<down>", '<cmd>echo "[USE J!!]"<CR>')

--------------------------------------------------------------------------------
-- ◢◤ WINDOW & BUFFER MANAGEMENT ◢◤
--------------------------------------------------------------------------------
map.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
map.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
map.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })
map.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })
map.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Height" })
map.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Height" })
map.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Width" })
map.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Width" })
map.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map.set("n", "<leader>bd", function()
	Snacks.bufdelete()
end, { desc = "Delete Buffer" })
map.set("n", "<leader>bo", function()
	Snacks.bufdelete.other()
end, { desc = "Delete Other Buffers" })

--------------------------------------------------------------------------------
-- ◢◤ EDITING & LINE MANIPULATION ◢◤
--------------------------------------------------------------------------------
map.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
map.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
map.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
map.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- Undo Breakpoints
map.set("i", ",", ",<c-g>u")
map.set("i", ".", ".<c-g>u")
map.set("i", ";", ";<c-g>u")

-- Indent
map.set("x", "<", "<gv")
map.set("x", ">", ">gv")

-- Comment Lines
map.set("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Comment Below" })
map.set("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Comment Above" })

--------------------------------------------------------------------------------
-- ◢◤ SYSTEM & UTILS ◢◤
--------------------------------------------------------------------------------
map.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
map.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

--------------------------------------------------------------------------------
-- ◢◤ DIAGNOSTIC NAVIGATION (STABILITY MONITOR) ◢◤
--------------------------------------------------------------------------------
map.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next Diagnostic" })
map.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Prev Diagnostic" })
map.set("n", "]e", function()
	vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
end, { desc = "Next Error" })
map.set("n", "[e", function()
	vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
end, { desc = "Prev Error" })
map.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics (Manual)" })
map.set("n", "<leader>xd", vim.diagnostic.setqflist, { desc = "Diagnostic List (Quickfix)" })
