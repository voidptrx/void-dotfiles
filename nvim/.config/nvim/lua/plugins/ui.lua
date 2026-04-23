return {
	{ -- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		event = "VimEnter",
		---@module 'which-key'
		---@type wk.Opts
		---@diagnostic disable-next-line: missing-fields
		opts = {
			delay = 0,
			icons = { mappings = vim.g.have_nerd_font },
			spec = {
				{ "<leader>s", group = "[S]earch", mode = { "n", "v" } },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
				{ "gr", group = "LSP Actions", mode = { "n" } },
			},
		},
	},

	{ -- Colorscheme
		"rebelot/kanagawa.nvim",
		priority = 1000,
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("kanagawa").setup({
				compile = false,
				undercurl = true,
				commentStyle = { italic = false },
				functionStyle = {},
				keywordStyle = { italic = false },
				statementStyle = { bold = true },
				typeStyle = {},
				transparent = false,
				dimInactive = false,
				terminalColors = true,
				overrides = function(_colors)
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
					}
				end,
				theme = "dragon",
				background = { dark = "wave", light = "lotus" },
			})
			vim.cmd.colorscheme("kanagawa-dragon")
		end,
	},

	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		---@module 'todo-comments'
		---@type TodoOptions
		---@diagnostic disable-next-line: missing-fields
		opts = { signs = false },
	},

	{ -- Collection of various small independent plugins/modules
		"nvim-mini/mini.nvim",
		config = function()
			require("mini.ai").setup({ n_lines = 500 })
			require("mini.surround").setup()
			require("mini.pairs").setup()
		end,
	},

	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			bigfile = { enabled = true },
			explorer = {
				enabled = true,
				search = false,
				cwd = function()
					local dir = vim.fn.expand("%:p:h")
					return dir ~= "" and dir or vim.uv.cwd()
				end,
			},
			indent = { enabled = true },
			input = { enabled = true },
			picker = { enabled = true },
			notifier = { enabled = true },
			quickfile = { enabled = true },
			scope = { enabled = true },
			scroll = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
			dashboard = {
				preset = {
					header = [[
╔╦═══════════════════════════════════════╦╗
  ║║  >_ REVACHOL CENTRAL MAINFRAME  _<   ║║
  ╠╬═══════════════════════════════════════╬╣
  ║║                                       ║║
  ║║  ░▒▓ F.U.C.K ▓▒░▒▓ T.H.E ▓▒░         ║║
  ║║                                       ║║
  ║║  ░▒▓ W.O.R.L.D ▓▒░                   ║║
  ║║                                       ║║
  ╠╬═══════════════════════════════════════╬╣
  ║║  [PALE ENCROACHMENT: ████████░░ 81%] ║║
  ║║  [RCM UPLINK: OFFLINE]               ║║
  ║║  [USER: HARRIER // BADGE: LOST]      ║║
  ╚╩═══════════════════════════════════════╩╝
]],
          -- stylua: ignore
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", 
              action = function()
                local real_path = vim.fn.resolve(vim.fn.stdpath("config"))
                vim.api.nvim_set_current_dir(real_path)
                Snacks.dashboard.pick('files', {
                  cwd = real_path,
                  follow = true,
                  hidden = true
                })
              end
            },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
				},
				formats = {
					key = function(item)
						return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
					end,
				},
				sections = {
					{ section = "header" },
					{ icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
					{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
					{ icon = " ", title = "Projects", section = "projects", limit = 5, indent = 2, padding = 1 },
				},
			},
		},
		keys = {
			{
				"<leader>si",
				function()
					Snacks.picker.icons()
				end,
				desc = "Icons",
			},
			{
				"<leader>e",
				function()
					Snacks.explorer({
						title = "Files",
					})
				end,
				desc = "Open file explorer (root dir)",
			},
			{
				"<leader>E",
				function()
					Snacks.explorer({
						cwd = vim.fn.expand("%:p:h"),
						title = "Files (cwd)",
					})
				end,
				desc = "Open file explorer (cwd)",
			},
		},
	},

	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		keys = {
			{ "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
			{ "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
			{ "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
			{ "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
			{ "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
			{ "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
			{ "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
			{ "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
			{ "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
			{ "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
			{ "<leader>bj", "<cmd>BufferLinePick<cr>", desc = "Pick Buffer" },
			{
				"<leader>bd",
				function()
					Snacks.bufdelete()
				end,
				desc = "Delete Buffer",
			},
		},
		opts = {
			highlights = {
				buffer_selected = {
					italic = false,
				},
				diagnostic_selected = { italic = false },
				error_selected = { italic = false },
				error_diagnostic_selected = { italic = false },
				warning_selected = { italic = false },
				warning_diagnostic_selected = { italic = false },
				info_selected = { italic = false },
				info_diagnostic_selected = { italic = false },
				hint_selected = { italic = false },
				hint_diagnostic_selected = { italic = false },
			},
			options = {
      -- stylua: ignore
      close_command = function(n) Snacks.bufdelete(n) end,
      -- stylua: ignore
      right_mouse_command = function(n) Snacks.bufdelete(n) end,
				diagnostics = "nvim_lsp",
				always_show_bufferline = false,
				offsets = {
					{
						filetype = "snacks_picker_list",
						text = "Pale Explorer",
						text_align = "left",
						highlight = "Directory",
						separator = true,
					},
					{
						filetype = "snacks_layout_box",
					},
				},
			},
		},
		config = function(_, opts)
			require("bufferline").setup(opts)
			-- Fix bufferline when restoring a session
			vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
				callback = function()
					vim.schedule(function()
						pcall(nvim_bufferline)
					end)
				end,
			})
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = function()
			local icons = {
				git = { added = "+", modified = "~", removed = "-" },
				diagnostics = { Error = "X", Warn = "!", Hint = "?", Info = "i" },
			}

			local black_theme = {
				normal = {
					a = { bg = "#000000", gui = "bold" },
					b = { bg = "#000000" },
					c = { bg = "#000000" },
				},
				insert = { a = { fg = "#76946a", bg = "#000000", gui = "bold" } },
				visual = { a = { fg = "#957fb8", bg = "#000000", gui = "bold" } },
				replace = { a = { fg = "#c0a36e", bg = "#000000", gui = "bold" } },
				command = { a = { fg = "#c34043", bg = "#000000", gui = "bold" } },
				inactive = {
					a = { bg = "#000000" },
					b = { bg = "#000000" },
					c = { bg = "#000000" },
				},
			}

			return {
				options = {
					theme = black_theme,
					globalstatus = true,
					icons_enabled = true,
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
				},
				sections = {
					lualine_a = {
						{
							"mode",
							fmt = function(str)
								return str:lower()
							end,
							icon = { "" },
							color = { gui = "bold" },
						},
					},
					lualine_b = {
						{
							"filename",
							file_status = true,
							path = 4,
							icon_only = true,
							padding = { left = 1, right = 0 },
						},
					},
					lualine_c = {
						{ "branch", color = { gui = "bold" } },
						{
							"diff",
							symbols = {
								added = icons.git.added,
								modified = icons.git.modified,
								removed = icons.git.removed,
							},
							color = { gui = "bold" },
						},
						{
							"diagnostics",
							symbols = {
								error = icons.diagnostics.Error,
								warn = icons.diagnostics.Warn,
								info = icons.diagnostics.Info,
								hint = icons.diagnostics.Hint,
							},
							color = { gui = "bold" },
						},
					},
					lualine_x = {},
					lualine_y = {
						{
							function()
								local msg = "No Active Lsp"
								local clients = vim.lsp.get_clients({ bufnr = 0 })
								if not clients or #clients == 0 then
									return " " .. msg
								end
								return " " .. clients[1].name
							end,
						},
					},
					lualine_z = {
						{ "progress", color = { gui = "bold" } },
						{ "location", color = { gui = "bold" } },
					},
				},
			}
		end,
	},
}
