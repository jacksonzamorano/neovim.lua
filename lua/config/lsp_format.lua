local function format()
	local buf = vim.api.nvim_get_current_buf()
	local filename = vim.api.nvim_buf_get_name(buf)
	local ft = vim.bo[buf].filetype

	vim.cmd("update")

	local prettierTypes = {
		javascript = true,
		javascriptreact = true,
		typescript = true,
		typescriptreact = true,
		vue = true,
		svelte = true,
		css = true,
		scss = true,
		less = true,
		html = true,
		json = true,
		jsonc = true,
		yaml = true,
	}
	if prettierTypes[ft] == true then
		local cmd = { "npx", "prettier", "--write", filename }
		local result = vim.fn.system(cmd)

		if vim.v.shell_error ~= 0 then
			vim.notify("Prettier error:\n" .. result, vim.log.levels.ERROR)
			return
		end
	else
		vim.lsp.buf.format({
			bufnr = buf,
		})
	end
	vim.cmd("checktime")
end
vim.keymap.set('n', '<leader>r', format)
