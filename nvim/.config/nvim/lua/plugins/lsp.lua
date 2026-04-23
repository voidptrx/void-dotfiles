return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason.nvim", opts = {} },
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"saghen/blink.cmp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(event)
					local opts = { buffer = event.buf }
					vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "x" }, "gra", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "grD", vim.lsp.buf.declaration, opts)

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client:supports_method("textDocument/inlayHint") then
						vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
					end
				end,
			})

			local servers = {
				lua_ls = {
					settings = { Lua = { workspace = { checkThirdParty = false } } },
				},
				ts_ls = {},
				marksman = {},
			}

			require("mason-tool-installer").setup({
				ensure_installed = {
					"lua-language-server",
					"typescript-language-server",
					"stylua",
					"shfmt",
					"prettier",
				},
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			for name, config in pairs(servers) do
				config.capabilities = capabilities
				vim.lsp.config(name, config)
				vim.lsp.enable(name)
			end
		end,
	},

	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				sh = { "shfmt" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				json = { "prettier" },
				jsonc = { "prettier" },
				markdown = { "prettier" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},
	},

	{
		"catgoose/nvim-colorizer.lua",
		event = "BufReadPre",
		opts = {},
	},
}
