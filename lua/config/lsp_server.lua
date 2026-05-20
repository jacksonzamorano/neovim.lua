vim.lsp.enable({ 'lua_ls', 'vtsls', 'gopls' })
vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" }
			}
		}
	}
})
