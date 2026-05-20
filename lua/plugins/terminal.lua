local util = require('util')
util.leaderBind({
	key = 't',
	default = 'centermax',
	exec = function(direction)
		util.floatingTerm({
			cmd = "zsh",
			h = 0.9,
			w = 0.3,
			title = "Quick Terminal",
			relayout = true,
			align = direction
		})
	end
})
