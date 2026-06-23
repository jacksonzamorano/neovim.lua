local langs = {
	"go",
	"gomod",
	"gosum",
	"gowork",
	"lua",
	"vim",
	"vimdoc",
	"markdown",
	"markdown_inline",
	"html",
	"yaml",
}

require("nvim-treesitter").install(langs)
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local ft = vim.bo[args.buf].filetype
		local lang = vim.treesitter.language.get_lang(ft) or ft

		local found = false
		for _, v in ipairs(langs) do
			if v == lang then
				found = true
			end
		end
		if found == false then return end

		local ok = pcall(vim.treesitter.language.add, lang)
		if not ok then
			return
		end

		vim.treesitter.start(args.buf, lang)
	end,
})
