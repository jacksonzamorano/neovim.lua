vim.keymap.set('n', '<leader>q', function()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == "qf" then
			vim.api.nvim_win_close(win, true)
		end
	end
end)
vim.keymap.set('n', '<leader>n', ':e %:h/')
