return {
	{
		"mrcjkb/rustaceanvim",
		ft = { "rust" },
		config = function()
			vim.g.rustaceanvim = {
				server = {
					on_attach = function(_, bufnr)
						vim.keymap.set("n", "<leader>cR", function()
							vim.cmd.RustLsp("codeAction")
						end, { desc = "Code Action", buffer = bufnr })
						vim.keymap.set("n", "<leader>dr", function()
							vim.cmd.RustLsp("debuggables")
						end, { desc = "Rust Debuggables", buffer = bufnr })
						vim.keymap.set("n", "<leader>k", function()
							vim.cmd.RustLsp("renderDiagnostic")
						end, { desc = "Render Diagnostics", buffer = bufnr })
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

	-- {
	-- 	"alexpasmantier/krust.nvim",
	-- 	ft = "rust",
	-- 	opts = {
	-- 		keymap = "<leader>k",
	-- 	},
	-- },
}
