local ALERTS_FILTER = [==[
local colors = {
	note = "#7e9cd8",
	tip = "#76946a",
	important = "#957fb8",
	warning = "#c0a36e",
	caution = "#c34043",
}

function BlockQuote(el)
	local first = el.content[1]
	if not first or first.t ~= "Para" then
		return nil
	end
	local tag = first.content[1]
	if not tag or tag.t ~= "Str" then
		return nil
	end

	local kind = tag.text:match("^%[!(%a+)%][+-]?$")
	local col = kind and colors[kind:lower()]
	if not col then
		return nil
	end

	first.content:remove(1)
	local nxt = first.content[1]
	if nxt and (nxt.t == "SoftBreak" or nxt.t == "LineBreak") then
		first.content:remove(1)
	end

	local title = kind:sub(1, 1):upper() .. kind:sub(2):lower()
	local open = string.format(
		'#block(width: 100%%, inset: (left: 10pt, y: 6pt), stroke: (left: 2.5pt + rgb("%s")))'
			.. '[#text(weight: "bold", fill: rgb("%s"))[%s]\n\n',
		col, col, title
	)

	local out = pandoc.List({ pandoc.RawBlock("typst", open) })
	if #first.content > 0 then
		out:insert(first)
	end
	for i = 2, #el.content do
		out:insert(el.content[i])
	end
	out:insert(pandoc.RawBlock("typst", "]"))
	return out
end
]==]

local function ensure_filter()
	local dir = vim.fn.stdpath("cache") .. "/md-pdf"
	local path = dir .. "/alerts.lua"
	vim.fn.mkdir(dir, "p")

	local f = io.open(path, "r")
	local current = f and f:read("*a")
	if f then
		f:close()
	end

	if current ~= ALERTS_FILTER then
		local w = assert(io.open(path, "w"))
		w:write(ALERTS_FILTER)
		w:close()
	end
	return path
end

local source = debug.getinfo(1, "S").source:sub(2)
local dir = vim.fn.fnamemodify(source, ":p:h")
local template = dir .. "/kanagawa-theme.typst"

local function export_pdf(buf, open)
	local src = vim.api.nvim_buf_get_name(buf)
	local out = vim.fn.fnamemodify(src, ":r") .. ".pdf"

	vim.system(
		{
			"pandoc",
			src,
			"-o",
			out,
			"--pdf-engine=typst",
			"--lua-filter",
			ensure_filter(),
			"-V",
			"mainfont=Terminess Nerd Font Propo",
			"--template",
			template,
		},
		{ text = true },
		vim.schedule_wrap(function(r)
			if r.code ~= 0 then
				return vim.notify(r.stderr, vim.log.levels.ERROR)
			end
			vim.notify("PDF hazır: " .. out)
			if open then
				vim.system({ "xdg-open", out })
			end
		end)
	)
end

return {
	{
		"delphinus/md-render.nvim",
		version = "*",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons", version = "*" },
			{ "delphinus/budoux.lua", version = "*" },
		},
		init = function()
			local aug = vim.api.nvim_create_augroup("MdPdf", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				group = aug,
				pattern = "markdown",
				callback = function(ev)
					vim.api.nvim_buf_create_user_command(ev.buf, "MdPdf", function()
						export_pdf(ev.buf, true)
					end, { desc = "Markdown -> PDF (pandoc + typst)" })
				end,
			})
		end,
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
			{
				"<leader>mx",
				function()
					export_pdf(vim.api.nvim_get_current_buf(), true)
				end,
				ft = "markdown",
				desc = "Markdown -> PDF",
			},
		},
	},
}
