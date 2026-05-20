vim.keymap.set({ 'n', 'i' }, '<C-d>', vim.diagnostic.open_float)
vim.keymap.set({ 'i' }, '<C-k>', vim.lsp.buf.signature_help)
vim.keymap.set('n', 'K', vim.lsp.buf.hover)
vim.keymap.set('n', 'R', function()
	vim.ui.input({
		prompt = "Rename: "
	}, function(name)
		vim.lsp.buf.rename(name)
	end)
end)
vim.keymap.set('n', '[e', function()
	vim.diagnostic.jump({
		count = 1,
		wrap = true,
		severity = vim.diagnostic.severity.ERROR,
	})
end)
vim.keymap.set('n', ']e', function()
	vim.diagnostic.jump({
		count = 1,
		wrap = true,
		severity = vim.diagnostic.severity.ERROR,
	})
end)

local ops = {
	d = vim.lsp.buf.definition,
	D = vim.lsp.buf.type_definition,
	r = vim.lsp.buf.references,
	i = vim.lsp.buf.implementation,
	I = vim.lsp.buf.incoming_calls,
}
for k, v in pairs(ops) do
	vim.keymap.set('n', 'g' .. k, v)
	vim.keymap.set('n', 'gv' .. k, function()
		vim.cmd.vsplit()
		v()
	end)
	vim.keymap.set('n', 'gh' .. k, function()
		vim.cmd.split()
		v()
	end)
end
vim.keymap.set('n', 'ga', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>fl', function()
	vim.lsp.buf.format()
	vim.cmd('update')
end)
