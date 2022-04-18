require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"python",
		"typescript",
		"javascript",
	},
	indent = { enable = true, disable = { "python" } },
	highlight = { enable = true },
})
