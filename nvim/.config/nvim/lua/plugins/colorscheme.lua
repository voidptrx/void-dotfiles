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
}
