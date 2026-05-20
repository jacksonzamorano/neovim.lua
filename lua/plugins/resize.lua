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
