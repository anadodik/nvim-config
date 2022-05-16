local M = {}

local servers = {
	html = {},
	jsonls = {},
	pyright = {
		handlers = {
			["textDocument/publishDiagnostics"] = function() end,
		},
	},
	sumneko_lua = {},
	svelte = {},
	tsserver = {},
}

local lsp_signature = require("lsp_signature")
lsp_signature.setup({
	bind = true,
	handler_opts = {
		border = "rounded",
	},
})

local format_timeout = 1000

local enable_formatting = function(client)
	if client.resolved_capabilities.document_formatting then
		vim.api.nvim_create_autocmd(string.format("BufWritePre %s", "*"), {
			callback = function()
				vim.lsp.buf.formatting_sync(nil, format_timeout)
			end,
		})
	end
end

local function on_attach(client, bufnr)
	-- Enable completion triggered by <C-X><C-O>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	if client.name ~= "null-ls" then
		client.resolved_capabilities.document_formatting = false
		client.resolved_capabilities.document_range_formatting = false
	else
		-- Use LSP as the handler for formatexpr.
		vim.api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr()")
		enable_formatting(client)
	end

	-- Configure key mappings
	require("plugins.lsp.keymaps").setup(client, bufnr)
end

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

local opts = {
	on_attach = on_attach,
	capabilities = capabilities,
	flags = {
		debounce_text_changes = 1000,
	},
}

-- Setup LSP handlers
require("plugins.lsp.handlers").setup()

function M.setup()
	require("plugins.lsp.installer").setup(servers, opts)

	require("plugins.lsp.null-ls").setup(opts)
end

return M
