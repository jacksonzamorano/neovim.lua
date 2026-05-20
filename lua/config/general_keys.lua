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
