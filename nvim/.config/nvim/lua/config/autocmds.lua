-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	callback = function()
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true, silent = true })
	end,
})

-- Disabled italic text
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
			local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
			if hl.italic then
				hl.italic = false
				vim.api.nvim_set_hl(0, group, hl)
			end
		end
	end,
})
