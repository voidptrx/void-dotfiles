local icons = {
	Error = "E:",
	Warn = "W:",
	Hint = "H:",
	Info = "I:",
}

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = icons.Error,
			[vim.diagnostic.severity.WARN] = icons.Warn,
			[vim.diagnostic.severity.HINT] = icons.Hint,
			[vim.diagnostic.severity.INFO] = icons.Info,
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
			[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
		},
	},
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "single",
		source = "if_many",
		format = function(diag)
			if diag.source then
				return string.format("[%s] %s", diag.source, diag.message)
			end
			return diag.message
		end,
	},
	underline = { severity = { min = vim.diagnostic.severity.WARN } },
	virtual_text = {
		prefix = "[X]",
	},
	virtual_lines = false,
	jump = {
		on_jump = function()
			vim.diagnostic.open_float()
		end,
	},
})

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"mason.nvim",
				opts = {
					ui = {
						icons = {
							package_installed = "+",
							package_pending = "->",
							package_uninstalled = "x",
						},
					},
				},
			},
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"saghen/blink.cmp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(event)
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if not client then
						return
					end

					if client.name == "rust_analyzer" then
						return
					end

					local map = function(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
					end

					map("n", "grn", vim.lsp.buf.rename, "Rename")
					map({ "n", "x" }, "gra", vim.lsp.buf.code_action, "Code Action")
					map("n", "grD", vim.lsp.buf.declaration, "Goto Declaration")
					map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
					map("n", "gr", vim.lsp.buf.references, "References")
					map("n", "gI", vim.lsp.buf.implementation, "Goto Implementation")
					map("n", "gy", vim.lsp.buf.type_definition, "Goto Type Definition")
					map("n", "K", vim.lsp.buf.hover, "Hover")
					map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
					map("i", "<c-k>", vim.lsp.buf.signature_help, "Signature Help")
					map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
					map("n", "<leader>cc", vim.lsp.codelens.run, "Run Codelens")
					map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
					map("n", "<leader>co", function()
						vim.lsp.buf.code_action({
							apply = true,
							context = { only = { "source.organizeImports" }, diagnostics = {} },
						})
					end, "Organize Imports")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client:supports_method("textDocument/inlayHint") then
						vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
					end
				end,
			})

			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
								library = vim.api.nvim_get_runtime_file("", true),
							},
							diagnostics = {
								globals = { "vim" },
							},
						},
					},
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
		"nvim-mini/mini.nvim",
		config = function()
			require("mini.ai").setup({ n_lines = 500 })
			require("mini.surround").setup()
			require("mini.pairs").setup()
		end,
	},
	{
		"catgoose/nvim-colorizer.lua",
		event = "BufReadPre",
		opts = {},
	},
}
