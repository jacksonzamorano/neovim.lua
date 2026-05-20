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
vim.pack.add({
	"https://github.com/catppuccin/nvim.git",
	"https://github.com/neovim/nvim-lspconfig.git",
	"https://github.com/nvim-mini/mini.pick.git",
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

require('config.lsp_server')
require('config.lsp_completion')
require('config.lsp_binds')
require('config.lsp_format')
require('config.lsp_quickfix')
