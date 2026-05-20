require("nvim-treesitter").install({
	"go",
	"gomod",
	"gosum",
	"gowork",
	"lua",
	"vim",
	"vimdoc",
	"markdown",
	"markdown_inline",
})
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local excludes = {
			minipick = true
		}

		local ft = vim.bo[args.buf].filetype
		if excludes[ft] == true then
			return
		end
		local lang = vim.treesitter.language.get_lang(ft) or ft

		local ok = pcall(vim.treesitter.language.add, lang)
		if not ok then
			return
		end

		vim.treesitter.start(args.buf, lang)
	end,
})
