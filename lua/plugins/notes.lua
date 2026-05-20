local util = require('util')

util.leaderBind({
	key = '\'',
	default = 'right',
	exec = function(direction)
		local path = vim.fn.fnamemodify(".git/NOTES.md", ":p")
		local buf = vim.fn.bufadd(path)
		local win = util.focusBuf(buf)
		if win == nil then
			if not vim.api.nvim_buf_is_loaded(buf) then
				vim.fn.bufload(buf)
			end
			vim.bo[buf].buftype = ""
			vim.bo[buf].swapfile = false
			vim.bo[buf].bufhidden = "hide"
			_, win = util.modal({
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
			util.closeWindow(win)
		end, { buffer = buf })
		vim.keymap.set({ 'n', 'i' }, '<C-q>', function()
			vim.cmd [[update]]
			util.closeWindow(win)
		end, { buffer = buf })
	end
})

