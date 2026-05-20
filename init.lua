-- Global
vim.opt.textwidth = 120
vim.opt.formatoptions = 'jcroql'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.winborder = "rounded"
vim.o.splitbelow = true
vim.o.splitright = true
vim.g.mapleader = ' '

-- Util
local leaderBind = function(args)
	vim.keymap.set('n', "<Leader>" .. args.key, function()
		args.exec(args.default)
	end)
	vim.keymap.set('n', '<Leader>w' .. args.key, function()
		args.exec('top')
	end)
	vim.keymap.set('n', '<Leader>s' .. args.key, function()
		args.exec('bottom')
	end)
	vim.keymap.set('n', '<Leader>a' .. args.key, function()
		args.exec('left')
	end)
	vim.keymap.set('n', '<Leader>d' .. args.key, function()
		args.exec('right')
	end)
end
local closeWindow = function(win)
	if vim.api.nvim_win_is_valid(win) then
		vim.api.nvim_win_close(win, true)
	end
end
local focusBuf = function(buf)
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == buf then
			vim.api.nvim_set_current_win(win)
			return win
		end
	end
	return nil
end
local modal = function(args)
	local buf
	if args["buffer"] then
		buf = args.buffer
	else
		buf = vim.api.nvim_create_buf(false, true)
	end
	local width = math.floor(vim.o.columns * args.w)
	local height = math.floor(vim.o.lines * args.h)

	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local vpad = 2
	local hpad = 4

	if args.align == "top" then
		row = vpad
		if args.relayout == true then
			width = math.floor(vim.o.columns * args.h)
			height = math.floor(vim.o.lines * args.w)
		end
	elseif args.align == "bottom" then
		row = vim.o.lines - vpad
		if args.relayout == true then
			width = math.floor(vim.o.columns * args.h)
			height = math.floor(vim.o.lines * args.w)
		end
	elseif args.align == "right" then
		col = vim.o.columns - width - hpad
	elseif args.align == "left" then
		col = hpad
	elseif args.align == "centermax" and args.relayout == true then
		local max = args.h
		if args.w > max then
			max = args.w
		end
		width = math.floor(vim.o.columns * max)
		height = math.floor(vim.o.lines * max)
		row = math.floor((vim.o.lines - height) / 2)
		col = math.floor((vim.o.columns - width) / 2)
	elseif args.align == "centermin" and args.relayout == true then
		local min = args.h
		if args.w < min then
			min = args.w
		end
		width = math.floor(vim.o.columns * min)
		height = math.floor(vim.o.lines * min)
		row = math.floor((vim.o.lines - height) / 2)
		col = math.floor((vim.o.columns - width) / 2)
	end

	local opts = {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		border = "rounded",
		title = args.title,
	}
	if args.inline == true then
		opts.style = "minimal"
	end

	local win = vim.api.nvim_open_win(buf, true, opts)
	vim.keymap.set('n', 'q', function()
		closeWindow(win)
	end, { buffer = buf })
	return buf, win
end
local floatingTerm = function(args)
	local buf, win = modal(args)
	vim.fn.termopen(args.cmd)
	vim.api.nvim_create_autocmd("TermClose", {
		buffer = buf,
		once = true,
		callback = function()
			closeWindow(win)
		end,
	})
	vim.cmd("startinsert")
end

-- Save, edit, close
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<C-q>', ':quit<CR>')
vim.keymap.set('n', '`', ':e #<CR>')

-- Windowing
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>')
vim.keymap.set('n', '<Leader>`', function()
	vim.cmd.vsplit()
	vim.cmd.edit('#')
end)
vim.keymap.set('n', '<Leader>]', vim.cmd.vsplit)
vim.keymap.set('n', '<Leader>[', vim.cmd.split)

-- Terminals
vim.keymap.set("t", "<C-Space>", [[<C-\><C-n>]], { noremap = true })

-- Lazygit
vim.keymap.set('n', '<Leader>c', function()
	floatingTerm({
		cmd = "lazygit",
		h = 0.9,
		w = 0.9,
		title = "Git"
	})
end)
vim.keymap.set('n', '<Leader>k', function()
	local file_buf = vim.api.nvim_get_current_buf()
	local line = vim.api.nvim_win_get_cursor(0)[1]
	local path = vim.api.nvim_buf_get_name(file_buf)
	local local_path = vim.fn.fnamemodify(path, ":p")
	vim.print(local_path)

	local h_factor = 0.9
	local buf, win = modal({
		h = h_factor,
		w = 0.9,
		title = "Blame " .. local_path,
		inline = true,
	})
	local lines = math.floor(vim.o.lines * h_factor)

	local lineDiff = math.floor(lines / 2)
	local cursorPos = lineDiff
	local startLine = (line - lineDiff)
	if startLine < 0 then
		cursorPos = cursorPos + startLine
		startLine = 0
	end


	local lineArgs = (startLine + 1) .. ',' .. (line + lineDiff)
	local out = vim.system({ 'git', 'blame', '--date=short', '--abbrev=6', '-L', lineArgs, '--', local_path }, {
		text = true,
	}):wait()
	vim.bo[buf].modifiable = true
	local display = out.stdout
	if out.code ~= 0 then
		display = out.stderr
	end
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(display, '\n'))
	vim.bo[buf].modifiable = false
	vim.api.nvim_win_set_cursor(win, { cursorPos, 0 })
end)
leaderBind({
	key = 't',
	default = 'centermax',
	exec = function(direction)
		floatingTerm({
			cmd = "zsh",
			h = 0.9,
			w = 0.3,
			title = "Quick Terminal",
			relayout = true,
			align = direction
		})
	end
})
leaderBind({
	key = '\'',
	default = 'right',
	exec = function(direction)
		local path = vim.fn.fnamemodify(".git/NOTES.md", ":p")
		local buf = vim.fn.bufadd(path)
		local win = focusBuf(buf)
		if win == nil then
			if not vim.api.nvim_buf_is_loaded(buf) then
				vim.fn.bufload(buf)
			end
			vim.bo[buf].buftype = ""
			vim.bo[buf].swapfile = false
			vim.bo[buf].bufhidden = "hide"
			_, win = modal({
				w = 0.3,
				h = 0.9,
				inline = false,
				buffer = buf,
				align = direction,
				relayout = true,
				title = "Notes",
			})
		end
		vim.keymap.set('n', '<Leader>\'', function()
			closeWindow(win)
		end, { buffer = buf })
		vim.keymap.set({ 'n', 'i' }, '<C-q>', function()
			vim.cmd [[update]]
			closeWindow(win)
		end, { buffer = buf })
	end
})

-- Emoji
vim.keymap.set('i', '<C-l>c', '✅')

-- Packages
vim.pack.add({
	"https://github.com/folke/tokyonight.nvim.git",
	"https://github.com/neovim/nvim-lspconfig.git",
	"https://github.com/nvim-mini/mini.pick.git",
	"https://github.com/nvim-treesitter/nvim-treesitter.git",
})

-- UI
vim.cmd('colorscheme tokyonight-moon')

-- Treesitter
require 'nvim-treesitter'.setup()

-- Pickers
require 'mini.pick'.setup()
vim.keymap.set('n', '<leader>e', ':Pick files<CR>')
vim.keymap.set('n', '<leader>g', ':Pick grep_live<CR>')
vim.keymap.set('n', '<leader>b', ':Pick buffers<CR>')
vim.keymap.set('n', '<leader>h', ':Pick help<CR>')

-- LSP
vim.lsp.enable({ 'lua_ls', 'vtsls', 'gopls' })
vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" }
			}
		}
	}
})


-- LSP.completion
vim.cmd [[set completeopt+=menuone,noinsert,popup]]
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, {
				autotrigger = true,
			})
		end
	end
})
vim.keymap.set("i", "<C-Space>", vim.lsp.completion.get)
vim.keymap.set("i", "<Tab>", function()
	return vim.fn.pumvisible() == 1 and "<C-y>" or "<Tab>"
end, { expr = true })


-- LSP.binds
vim.keymap.set({ 'n', 'i' }, '<C-d>', vim.diagnostic.open_float)
vim.keymap.set({ 'i' }, '<C-k>', vim.lsp.buf.signature_help)
vim.keymap.set('n', 'K', vim.lsp.buf.hover)
vim.keymap.set('n', 'R', function()
	vim.ui.input({
		prompt = "Rename: "
	}, function(name)
		vim.lsp.buf.rename(name)
	end)
end)
vim.keymap.set('n', '[e', function()
	vim.diagnostic.jump({
		count = 1,
		wrap = true,
		severity = vim.diagnostic.severity.ERROR,
	})
end)
vim.keymap.set('n', ']e', function()
	vim.diagnostic.jump({
		count = 1,
		wrap = true,
		severity = vim.diagnostic.severity.ERROR,
	})
end)

local ops = {
	d = vim.lsp.buf.definition,
	D = vim.lsp.buf.type_definition,
	r = vim.lsp.buf.references,
	i = vim.lsp.buf.implementation,
	I = vim.lsp.buf.incoming_calls,
}
for k, v in pairs(ops) do
	vim.keymap.set('n', 'g' .. k, v)
	vim.keymap.set('n', 'gv' .. k, function()
		vim.cmd.vsplit()
		v()
	end)
	vim.keymap.set('n', 'gh' .. k, function()
		vim.cmd.split()
		v()
	end)
end
vim.keymap.set('n', 'ga', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>fl', function()
	vim.lsp.buf.format()
	vim.cmd('update')
end)

-- Prettier
local function prettier_write()
	local buf = vim.api.nvim_get_current_buf()
	local filename = vim.api.nvim_buf_get_name(buf)

	if filename == "" then
		vim.notify("Prettier: buffer has no filename", vim.log.levels.WARN)
		return
	end

	-- Save file first
	vim.cmd("update")

	local view = vim.fn.winsaveview()

	local cmd = { "npx", "prettier", "--write", filename }
	local result = vim.fn.system(cmd)

	if vim.v.shell_error ~= 0 then
		vim.notify("Prettier error:\n" .. result, vim.log.levels.ERROR)
		return
	end

	-- Reload buffer from disk without prompting
	vim.cmd("checktime")
	vim.fn.winrestview(view)
end
vim.keymap.set('n', '<leader>fp', prettier_write)

-- Quickfix
vim.keymap.set('n', '<leader>q', function()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == "qf" then
			vim.api.nvim_win_close(win, true)
		end
	end
end)
vim.keymap.set('n', '<leader>n', ':e %:h/')

-- Resizing
local resize_mode = function()
	local maps = {}
	local resize_jump = 5

	local win = vim.api.nvim_get_current_win()
	local win_h_original = vim.api.nvim_get_option_value("winhighlight", { win = win })
	vim.api.nvim_set_option_value("winhighlight", "Normal:Visual,NormalNC:Visual", { win = win })

	local function map(lhs, rhs)
		vim.keymap.set("n", lhs, rhs, { silent = true, noremap = true })
		table.insert(maps, lhs)
	end

	local function clear_maps()
		for _, lhs in ipairs(maps) do
			pcall(vim.keymap.del, "n", lhs)
		end
		vim.api.nvim_echo({ { "", "Normal" } }, false, {})
		vim.api.nvim_set_option_value("winhighlight", win_h_original, { win = win })
		maps = {}
	end
	vim.api.nvim_echo({
		{ "Resize mode: h/l width, j/k height, q/Esc quit", "ModeMsg" },
	}, false, {})

	map("h", function() vim.cmd(("vertical resize -%d"):format(resize_jump)) end)
	map("l", function() vim.cmd(("vertical resize +%d"):format(resize_jump)) end)
	map("j", function() vim.cmd(("resize -%d"):format(resize_jump)) end)
	map("k", function() vim.cmd(("resize +%d"):format(resize_jump)) end)

	map("q", function()
		clear_maps()
	end)

	map("<Esc>", function()
		clear_maps()
	end)
end
vim.keymap.set('n', '<Leader>m', resize_mode)
