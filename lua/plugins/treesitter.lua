require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"python",
		"typescript",
		"javascript",
		"svelte",
		"html",
		"css",
		"json",
	},
	indent = { enable = true, disable = { "python" } },
	highlight = { enable = true },
})
