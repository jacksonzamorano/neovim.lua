-- require 'mini.pick'.setup()
-- vim.keymap.set('n', '<leader>e', ':Pick files<CR>')
-- vim.keymap.set('n', '<leader>g', ':Pick grep_live<CR>')
-- vim.keymap.set('n', '<leader>b', ':Pick buffers<CR>')
-- vim.keymap.set('n', '<leader>h', ':Pick help<CR>')
require 'telescope'.setup {

}
require('telescope').load_extension('fzf')

local builtin = require'telescope.builtin'
vim.keymap.set('n', '<leader>e', builtin.find_files)
vim.keymap.set('n', '<leader>g', builtin.live_grep)
vim.keymap.set('n', '<leader>b', builtin.buffers)
vim.keymap.set('n', '<leader>h', builtin.man_pages)
vim.keymap.set('n', '<leader>ld', builtin.diagnostics)
vim.keymap.set('n', '<leader>lc', builtin.git_bcommits)
vim.keymap.set('n', '<leader>lC', builtin.git_commits)
