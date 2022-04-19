local M = {}

local nls = require("null-ls")
local nls_utils = require("null-ls.utils")

local diagnostics = nls.builtins.diagnostics
local formatting = nls.builtins.formatting

local sources = {
	formatting.black,
	formatting.isort,
	diagnostics.mypy,
	diagnostics.flake8,
	formatting.prettier,
	formatting.stylua,
}

function M.setup(opts)
	nls.setup({
		-- debug = true,
		debounce = 500,
		save_after_format = false,
		sources = sources,
		on_attach = opts.on_attach,
		root_dir = nls_utils.root_pattern(".git"),
	})
end

return M
