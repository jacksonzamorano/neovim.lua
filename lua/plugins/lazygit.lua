local util = require('util')
vim.keymap.set('n', '<Leader>c', function()
	util.floatingTerm({
		cmd = "lazygit",
		h = 0.9,
		w = 0.9,
		title = "Git"
	})
end)
