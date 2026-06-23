-- Save, edit, close
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>', { silent = true })
vim.keymap.set('n', '<C-q>', ':quit<CR>', { silent = true })
vim.keymap.set('n', '`', ':e #<CR>', { silent = true })

-- Windowing
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', { silent = true })
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', { silent = true })
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', { silent = true })
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', { silent = true })
vim.keymap.set('n', '<Leader>`', function()
	vim.cmd.vsplit()
	vim.cmd.edit('#', { silent = true })
end)
vim.keymap.set('n', '<Leader>]', vim.cmd.vsplit)
vim.keymap.set('n', '<Leader>[', vim.cmd.split)

-- Terminals
vim.keymap.set("t", "<C-Space>", [[<C-\><C-n>]], { noremap = true, silent = true })

-- Search
vim.keymap.set("n", "<leader><space>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
