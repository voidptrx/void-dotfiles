return {
	{
		"delphinus/md-render.nvim",
		version = "*",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons", version = "*" }, -- optional: file type icons in code blocks
			{ "delphinus/budoux.lua", version = "*" }, -- optional: CJK phrase-level line breaking
		},
		keys = {
			{ "<leader>mp", "<Plug>(md-render-preview)", desc = "Markdown preview (toggle)" },
			{ "<leader>ms", "<Plug>(md-render-preview-tab)", desc = "Markdown preview in tab (toggle)" },
			{ "<leader>md", "<Plug>(md-render-demo)", desc = "Markdown render demo" },
			{
				"<leader>mv",
				function()
					vim.cmd("vert MdRender split")
				end,
				desc = "Markdown split (vertical)",
			},
		},
	},
}
