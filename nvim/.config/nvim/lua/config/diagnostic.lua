local icons = {
	Error = "X",
	Warn = "!",
	Hint = "?",
	Info = "i",
}

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = icons.Error,
			[vim.diagnostic.severity.WARN] = icons.Warn,
			[vim.diagnostic.severity.HINT] = icons.Hint,
			[vim.diagnostic.severity.INFO] = icons.Info,
		},
	},
	update_in_insert = true,
	severity_sort = true,
	float = { border = "single", source = "if_many" },
	underline = { severity = { min = vim.diagnostic.severity.WARN } },
	virtual_text = true,
	virtual_lines = false,
	jump = {
		on_jump = function()
			vim.diagnostic.open_float()
		end,
	},
})
