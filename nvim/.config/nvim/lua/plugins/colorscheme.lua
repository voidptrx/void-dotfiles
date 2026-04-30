return {
	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				commentStyle = { italic = false },
				keywordStyle = { italic = false },
				theme = "dragon",
				overrides = function(colors)
					return {
						Normal = { bg = "#000000" },
						NormalFloat = { bg = "#000000" },
						FloatBorder = { bg = "#000000" },
						SignColumn = { bg = "#000000" },
						LineNr = { bg = "#000000" },
						CursorLine = { bg = "#000000" },
						CursorLineNr = { bg = "#000000" },
						DiagnosticSignError = { bg = "#000000" },
						DiagnosticSignWarn = { bg = "#000000" },
						DiagnosticSignHint = { bg = "#000000" },
						DiagnosticSignInfo = { bg = "#000000" },
						GitSignsAdd = { bg = "#000000" },
						GitSignsChange = { bg = "#000000" },
						GitSignsDelete = { bg = "#000000" },
					}
				end,
			})
			vim.cmd.colorscheme("kanagawa-dragon")
		end,
	},
}
