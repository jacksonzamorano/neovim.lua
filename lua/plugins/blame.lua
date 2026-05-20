local util = require('util')
vim.keymap.set('n', '<Leader>k', function()
	local file_buf = vim.api.nvim_get_current_buf()
	local line = vim.api.nvim_win_get_cursor(0)[1]
	local path = vim.api.nvim_buf_get_name(file_buf)
	local local_path = vim.fn.fnamemodify(path, ":p")
	vim.print(local_path)

	local h_factor = 0.9
	local buf, win = util.modal({
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
