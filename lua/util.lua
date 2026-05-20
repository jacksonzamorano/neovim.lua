local M = {}
M.leaderBind = function(args)
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
M.focusBuf = function(buf)
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == buf then
			vim.api.nvim_set_current_win(win)
			return win
		end
	end
	return nil
end
M.modal = function(args)
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
M.floatingTerm = function(args)
	local buf, win = M.modal(args)
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

return M
