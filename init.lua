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

-- Bare minimum
require('config.general_keys')

-- Packages
vim.api.nvim_create_autocmd('PackChanged', {
	callback = function(ev)
		local spec = ev.data.spec
		local kind = ev.data.kind
		local path = ev.data.path
		if spec.name == 'telescope-fzf-native.nvim'
		    and (kind == 'install' or kind == 'update') then
			vim.system({ 'make' }, { cwd = path }):wait()
		end
	end
})
vim.pack.add({
	"https://github.com/catppuccin/nvim.git",
	"https://github.com/neovim/nvim-lspconfig.git",
	"https://github.com/nvim-treesitter/nvim-treesitter.git",
	"https://github.com/lewis6991/gitsigns.nvim.git",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope-fzf-native.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
})
vim.keymap.set('n', '<Leader>p', function()
	vim.pack.update(nil, {})
end)

vim.cmd('colorscheme catppuccin-mocha')

-- Custom
require('plugins.lazygit')
require('plugins.blame')
require('plugins.terminal')
require('plugins.notes')
require('plugins.treesitter')
require('plugins.pickers')
require('plugins.resize')
require('plugins.gitsigns')

require('config.lsp_server')
require('config.lsp_completion')
require('config.lsp_binds')
require('config.lsp_format')
require('config.lsp_quickfix')
