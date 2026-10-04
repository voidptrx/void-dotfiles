return {
	{
		"mrcjkb/rustaceanvim",
		-- version = "^9",
		lazy = false,
		init = function()
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
						map("K", function()
							vim.cmd.RustLsp({ "hover", "actions" })
						end, "Hover actions")
						map("<leader>rr", function()
							vim.cmd.RustLsp("runnables")
						end, "Runnables")
						map("<leader>rm", function()
							vim.cmd.RustLsp("expandMacro")
						end, "Expand macro")
						map("<leader>cc", vim.lsp.codelens.run, "Run Codelens")
						vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					end,
					default_settings = {
						["rust-analyzer"] = {
							cargo = { allFeatures = true, targetDir = true },
							check = {
								command = "clippy",
								extraArgs = { "--", "-W", "clippy::pedantic" },
							},
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
							},
						},
					},
				},
			}
		end,
	},
}
