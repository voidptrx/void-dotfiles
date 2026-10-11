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
	{
		"danhat1020/silence.nvim",
		priority = 1000,
		config = function()
			require("silence").setup({
				transparent = true,
				bold = true,
				darker_comments = true,
			})

			local function fix_tabline()
				local function get(name)
					return vim.api.nvim_get_hl(0, { name = name, link = false })
				end
				local normal = get("Normal")
				local comment = get("Comment")
				local set = vim.api.nvim_set_hl

				set(0, "TabLineFill", { bg = "NONE" })
				set(0, "TabLine", { fg = comment.fg, bg = "NONE" })
				set(0, "TabLineSel", { fg = comment.fg, bg = "NONE", bold = true })
			end

			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "silence",
				callback = fix_tabline,
			})

			-- vim.cmd.colorscheme("silence")
			-- fix_tabline()
		end,
	},
}
