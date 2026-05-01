return {
	{
		"mrcjkb/rustaceanvim",
		ft = { "rust" },
		config = function()
			vim.g.rustaceanvim = {
				server = {
					on_attach = function(_, bufnr)
						local map = function(lhs, rhs, desc)
							vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
						end

						map("<leader>cR", function()
							vim.cmd.RustLsp("codeAction")
						end, "Rust Code Action")
						map("<leader>dr", function()
							vim.cmd.RustLsp("debuggables")
						end, "Rust Debuggables")
						map("<leader>k", function()
							vim.cmd.RustLsp("renderDiagnostic")
						end, "Render Diagnostics")
						map("gd", vim.lsp.buf.definition, "Goto Definition")
						map("gr", vim.lsp.buf.references, "References")
						map("gI", vim.lsp.buf.implementation, "Goto Implementation")
						map("gy", vim.lsp.buf.type_definition, "Goto Type Definition")
						map("gK", vim.lsp.buf.signature_help, "Signature Help")
						map("<leader>cr", vim.lsp.buf.rename, "Rename")
						map("<leader>cc", vim.lsp.codelens.run, "Run Codelens")

						vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					end,

					default_settings = {
						["rust-analyzer"] = {
							cargo = {
								allFeatures = true,
								loadOutDirsFromCheck = true,
								buildScripts = { enable = true },
							},
							check = {
								command = "clippy",
								extraArgs = {
									"--",
									"-W",
									"clippy::pedantic",
								},
							},
							checkOnSave = true,
							diagnostics = { enable = true },
							procMacro = { enable = true },
							files = {
								exclude = {
									".direnv",
									".git",
									".jj",
									".github",
									".gitlab",
									"bin",
									"node_modules",
									"target",
									"venv",
									".venv",
								},
								watcher = "client",
							},
						},
					},
				},
			}
		end,
	},
}
