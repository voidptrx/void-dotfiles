return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			bigfile = { enabled = true },
			explorer = {
				enabled = true,
			},
			indent = { enabled = true },
			input = { enabled = true },
			picker = {
				enabled = true,
				sources = {
					explorer = {
						title = ">REVACHOL CENTRAL MAINFRAME<",
						layout = {
							preset = "sidebar",
						},
					},
				},
			},
			notifier = { enabled = true },
			quickfile = { enabled = true },
			scope = { enabled = true },
			scroll = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
			dashboard = {
				preset = {
					header = [[
╔╦═══════════════════════════════════════════════════╦╗
 ║║        >_ REVACHOL CENTRAL MAINFRAME _<         ║║
║║   >_ RCM TERMINAL // PRECINCT 41 // UNIT 57 _<   ║║
 ╠╬═══════════════════════════════════════════════════╬╣
 ║║              THE WORLD IS ENDING.               ║║
 ║║                 FUCK THE WORLD                    ║║
 ║║               SUNRISE, PARABELLUM                 ║║
 ╠╬═══════════════════════════════════════════════════╬╣
  ║║   [HOST: ThinkPad T480] [OS: Void Linux]           ║║
 ║║   [STATUS: DISCO ETERNAL]                        ║║
  ║║  [PALE ENCROACHMENT: █████░░░░░ 50%]             ║║
  ║║  [RCM UPLINK: OFFLINE]                          ║║
  ║║  [USER: HARRIER // BADGE: LOST]                  ║║
 ╚╩═══════════════════════════════════════════════════╝
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
		-- stylua: ignore
		keys = {
      { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
      { "<leader>E", function() Snacks.explorer() end, desc = "Explorer (root)" },
      { "<leader>e", function() Snacks.explorer({ cwd = vim.fn.expand("%:p:h") }) end, desc = "Explorer (cwd)" },
      { "<leader>sf", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Live Grep" },
      { "<leader>sr", function() Snacks.picker.recent() end, desc = "Recent Files" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sc", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>ss", function() Snacks.picker.pickers() end, desc = "Pickers" },
      { "<leader><leader>", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>/", function() Snacks.picker.lines() end, desc = "Search in Buffer" },
      { "<leader>s/", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Files" },
      { "<leader>sn", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Neovim Files" },
      { "grr", function() Snacks.picker.lsp_references() end, desc = "References" },
      { "gri", function() Snacks.picker.lsp_implementations() end, desc = "Implementations" },
      { "grd", function() Snacks.picker.lsp_definitions() end, desc = "Definitions" },
      { "gO", function() Snacks.picker.lsp_symbols() end, desc = "Document Symbols" },
      { "grt", function() Snacks.picker.lsp_type_definitions() end, desc = "Type Definitions" },
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
				close_command = function(n)
					Snacks.bufdelete(n)
				end,
				right_mouse_command = function(n)
					Snacks.bufdelete(n)
				end,
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
			vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
				callback = function()
					vim.schedule(function()
						pcall(require("bufferline").refresh)
					end)
				end,
			})
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = function()
			local symbols = {
				git = { added = "+", modified = "~", removed = "-" },
				diagnostics = { Error = "ERR:", Warn = "WRN:", Hint = "HNT:", Info = "INF:" },
			}

			local black_theme = {
				normal = {
					a = { fg = "#dcd7ba", bg = "#000000" },
					b = { fg = "#dcd7ba", bg = "#000000" },
					c = { fg = "#dcd7ba", bg = "#000000" },
				},
				insert = { a = { fg = "#76946a", bg = "#000000" } },
				visual = { a = { fg = "#957fb8", bg = "#000000" } },
				replace = { a = { fg = "#c0a36e", bg = "#000000" } },
				command = { a = { fg = "#c34043", bg = "#000000" } },
				inactive = {
					a = { fg = "#727169", bg = "#000000" },
					b = { fg = "#727169", bg = "#000000" },
					c = { fg = "#727169", bg = "#000000" },
				},
			}

			return {
				options = {
					theme = black_theme,
					globalstatus = true,
					icons_enabled = false,
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
				},
				sections = {
					lualine_a = {
						{
							"mode",
							fmt = function(str)
								local modes = {
									NORMAL = "DETECTIVE",
									INSERT = "INLAND EMPIRE",
									VISUAL = "LOGIC",
									["V-LINE"] = "PERCEPTION",
									["V-BLOCK"] = "SHIVERS",
									REPLACE = "ELECTROCHEMISTRY",
									COMMAND = "VOLITION",
								}
								return "[" .. (modes[str] or str) .. "]"
							end,
							color = { gui = "bold" },
						},
					},
					lualine_b = {
						{ "filetype", padding = { left = 1, right = 1 } },
						{ "filename", path = 4, file_status = true },
					},
					lualine_c = {
						{
							"branch",
							fmt = function(str)
								if str == nil or str == "" then
									return "DETACHED_UNIT"
								end
								return "BRNCH:" .. str
							end,
							color = { fg = "#7e9cd8" },
						},
						{
							"diff",
							symbols = symbols.git,
							colored = true,
						},
					},
					lualine_x = {
						{
							"diagnostics",
							symbols = {
								error = symbols.diagnostics.Error,
								warn = symbols.diagnostics.Warn,
								info = symbols.diagnostics.Info,
								hint = symbols.diagnostics.Hint,
							},
						},
					},
					lualine_y = {
						{
							function()
								local clients = vim.lsp.get_clients({ bufnr = 0 })
								if #clients == 0 then
									return "[UPLINK: OFFLINE]"
								end
								local names = {}
								for _, client in ipairs(clients) do
									table.insert(names, client.name:upper())
								end
								return "[UPLINK: " .. table.concat(names, "|") .. "]"
							end,
							color = { fg = "#76946a" },
						},
					},
					lualine_z = {
						{
							"location",
							fmt = function(str)
								return "LOC:" .. str
							end,
						},
						{
							"progress",
							fmt = function(str)
								return "PRG:" .. str
							end,
						},
					},
				},
			}
		end,
	},
}
