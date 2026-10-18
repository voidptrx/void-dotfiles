local ALERTS_FILTER = [==[
local colors = {
	note = "#7e9cd8",
	tip = "#76946a",
	important = "#957fb8",
	warning = "#c0a36e",
	caution = "#c34043",
	example = "#76946a",
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
	local open = kind:lower() == "example" and "#kg-example[\n\n" or string.format(
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

-- Existing lesson notes use a standalone Example: paragraph followed by the
-- example itself. Give that pair the same presentation as [!EXAMPLE] callouts.
function Blocks(blocks)
	if FORMAT ~= "typst" then
		return nil
	end
	local out = pandoc.List()
	local i = 1
	while i <= #blocks do
		local block = blocks[i]
		local next_block = blocks[i + 1]
		local label = block.t == "Para" and pandoc.utils.stringify(block.content) or ""
		if (label == "Example:" or label == "Examples:")
			and next_block and (next_block.t == "Para" or next_block.t == "Plain") then
			out:insert(pandoc.RawBlock("typst", "#kg-example[\n\n"))
			out:insert(next_block)
			out:insert(pandoc.RawBlock("typst", "]"))
			i = i + 2
		else
			out:insert(block)
			i = i + 1
		end
	end
	return out
end

function Table(el)
	if FORMAT ~= "typst" then
		return nil
	end
	local rows = {}
	for _, row in ipairs(el.head.rows) do rows[#rows + 1] = row end
	local body_rows = 0
	for _, body in ipairs(el.bodies) do
		for _, row in ipairs(body.head) do rows[#rows + 1] = row end
		for _, row in ipairs(body.body) do
			rows[#rows + 1] = row
			body_rows = body_rows + 1
		end
	end
	for _, row in ipairs(el.foot.rows) do rows[#rows + 1] = row end

	-- Give Japanese noun phrases room in Part / Role analysis tables.
	local header = el.head.rows[1]
	if #el.colspecs == 2 and header and #header.cells == 2
		and pandoc.utils.stringify(header.cells[1].contents) == "Part"
		and pandoc.utils.stringify(header.cells[2].contents) == "Role" then
		el.colspecs = { { el.colspecs[1][1], 0.5 }, { el.colspecs[2][1], 0.5 } }
	end

	-- Keep a small analysis table together, but allow tall/rich cells to flow.
	-- Row count alone is insufficient: even a two-row table can be very tall.
	local compact = body_rows <= 5 and #rows <= 7 and #el.colspecs <= 4
	local total = utf8.len(pandoc.utils.stringify(el.caption)) or 0
	for _, row in ipairs(rows) do
		for _, cell in ipairs(row.cells) do
			local size = utf8.len(pandoc.utils.stringify(cell.contents)) or 0
			total = total + size
			if size > 120 or cell.row_span > 1 then compact = false end
			for _, block in ipairs(cell.contents) do
				if block.t ~= "Para" and block.t ~= "Plain" then compact = false end
				block:walk({
					Image = function() compact = false end,
					Note = function() compact = false end,
					RawInline = function() compact = false end,
					Math = function() compact = false end,
				})
			end
		end
	end
	if compact and total <= 400 then
		return {
			pandoc.RawBlock("typst", "#block(breakable: false)[\n\n"),
			el,
			pandoc.RawBlock("typst", "]"),
		}
	end
	return el
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
			"mainfont=Noto Sans CJK JP",
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
