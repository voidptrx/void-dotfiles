return {
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				theme = "dragon",
				commentStyle = { italic = false },
				keywordStyle = { italic = false },
				colors = {
					theme = {
						dragon = {
							ui = {
								bg = "#000000",
								bg_gutter = "#000000",
								float = {
									bg = "#000000",
									bg_border = "#000000",
								},
							},
						},
					},
				},
				overrides = function()
					return {
						CursorLine = { bg = "#000000" },
					}
				end,
			})
			vim.cmd.colorscheme("kanagawa-dragon")
		end,
	},
	{
		"webhooked/kanso.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("kanso").setup({
				bold = false,
				italics = false,
				commentStyle = { italic = false },
				keywordStyle = { italic = false },
				foreground = "default",
				minimal = true,
				terminalColors = false,
				colors = {
					palette = {
						zenBg0 = "#000000",
					},
				},
				overrides = function()
					return {
						CursorLine = { bg = "#000000" },
						SignColumn = { bg = "#000000" },
						LineNr = { bg = "#000000" },
					}
				end,
			})
			-- vim.cmd.colorscheme("kanso-zen")
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

	{
		"vague-theme/vague.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("vague").setup({
				transparent = false, -- If true, background is not set
				bold = true, -- Disable bold globally
				italic = true, -- Disable italic globally
				on_highlights = function(hl, colors) end,
				colors = {
					bg = "#141415",
					inactiveBg = "#1c1c24",
					fg = "#cdcdcd",
					floatBorder = "#878787",
					line = "#252530",
					comment = "#606079",
					builtin = "#b4d4cf",
					func = "#c48282",
					string = "#e8b589",
					number = "#e0a363",
					property = "#c3c3d5",
					constant = "#aeaed1",
					parameter = "#bb9dbd",
					visual = "#333738",
					error = "#d8647e",
					warning = "#f3be7c",
					hint = "#7e98e8",
					operator = "#90a0b5",
					keyword = "#6e94b2",
					type = "#9bb4bc",
					search = "#405065",
					plus = "#7fa563",
					delta = "#f3be7c",
				},
			})
		end,
	},
	{
		"slugbyte/lackluster.nvim",
		lazy = false,
		priority = 1000,
		init = function()
			-- vim.cmd.colorscheme("lackluster")
			-- vim.cmd.colorscheme("lackluster-hack") -- my favorite
			-- vim.cmd.colorscheme("lackluster-mint")
		end,
	},
}
