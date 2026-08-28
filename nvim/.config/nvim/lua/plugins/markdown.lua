return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		opts = {},
	},

	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = "cd app && npm install",
		init = function()
			vim.g.mkdp_theme = "dark"
			vim.g.mkdp_auto_close = 1
			-- vim.g.mkdp_markdown_css = vim.fn.expand("~/.config/nvim/mkdp/style.css")

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				callback = function(ev)
					local base = { buffer = ev.buf, silent = true }
					vim.keymap.set(
						"n",
						"<leader>mp",
						"<cmd>MarkdownPreviewToggle<cr>",
						vim.tbl_extend("force", base, { desc = "Markdown Preview Toggle" })
					)
					vim.keymap.set(
						"n",
						"<leader>ms",
						"<cmd>MarkdownPreviewStop<cr>",
						vim.tbl_extend("force", base, { desc = "Markdown Preview Stop" })
					)
				end,
			})
		end,
	},

	-- vim.keymap.set("n", "<leader>tp", function()
	-- 	local file = vim.fn.expand("%")
	-- 	local output = vim.fn.expand("%:r") .. ".pdf"
	--
	-- 	vim.notify("PDF is compiling...", vim.log.levels.INFO)
	--
	-- 	vim.fn.jobstart({
	-- 		"pandoc",
	-- 		file,
	-- 		"--to=typst",
	-- 		"--pdf-engine=typst",
	-- 		"-M",
	-- 		"mainfont=monospace",
	-- 		"-o",
	-- 		output,
	-- 	}, {
	-- 		on_exit = function(_, code)
	-- 			if code == 0 then
	-- 				vim.notify("PDF ready: " .. output, vim.log.levels.INFO)
	-- 			else
	-- 				vim.notify("Pandoc error (exit code " .. code .. ")", vim.log.levels.ERROR)
	-- 			end
	-- 		end,
	-- 	})
	-- end, { desc = "Markdown → Typst PDF (pandoc)" }),
}
