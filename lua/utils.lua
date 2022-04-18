_G.dump = function(...)
	print(vim.inspect(...))
end

_G.prequire = function(...)
	local status, lib = pcall(require, ...)
	if status then
		return lib
	end
	return nil
end

local M = {}

function M.map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = M.merge(options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function M.buf_map(bufnr, mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = M.merge(options, opts)
	end
	vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, options)
end

function M.merge_list(tbl1, tbl2)
	for _, v in ipairs(tbl2) do
		table.insert(tbl1, v)
	end
	return tbl1
end

function M.merge(...)
	return vim.tbl_deep_extend("force", ...)
end

function M.split(str, sep)
	local res = {}
	for w in str:gmatch("([^" .. sep .. "]*)") do
		if w ~= "" then
			table.insert(res, w)
		end
	end
	return res
end

function M.get_active_lsp_client_names()
	local active_clients = vim.lsp.get_active_clients()
	local client_names = {}
	for _, client in pairs(active_clients or {}) do
		local buf = vim.api.nvim_get_current_buf()
		-- only return attached buffers
		if vim.lsp.buf_is_attached(buf, client.id) then
			table.insert(client_names, client.name)
		end
	end

	if not vim.tbl_isempty(client_names) then
		table.sort(client_names)
	end
	return client_names
end

function M.t(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.log(msg, hl, name)
	name = name or "Neovim"
	hl = hl or "Todo"
	vim.api.nvim_echo({ { name .. ": ", hl }, { msg } }, true, {})
end

function M.warn(msg, name)
	vim.notify(msg, vim.log.levels.WARN, { title = name })
end

function M.error(msg, name)
	vim.notify(msg, vim.log.levels.ERROR, { title = name })
end

function M.info(msg, name)
	vim.notify(msg, vim.log.levels.INFO, { title = name })
end

return M
