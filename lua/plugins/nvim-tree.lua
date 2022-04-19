require("nvim-tree").setup({
	open_on_setup_file = true,
	open_on_tab = true,
	view = {
		mappings = {
			list = {
				{ key = "-", action = "" },
			},
		},
	},
})

local function close_if_last(opts)
	local open_windows = vim.api.nvim_tabpage_list_wins(0)
	local non_float_wins = vim.tbl_filter(function(k)
		return vim.api.nvim_win_get_config(k).relative == ""
	end, open_windows)
	-- print(vim.api.nvim_tabpage_get_number(0))
	-- print(vim.inspect(opts))
	-- print(vim.inspect(open_windows))
	-- print(string.find(opts.file, "NvimTree_"))
	if #non_float_wins == 1 and string.find(opts.file, "NvimTree_") then
		if #vim.api.nvim_list_tabpages() == 1 then
			vim.api.nvim_command([[ :quitall! ]])
		else
			for _, win in pairs(non_float_wins) do
				vim.api.nvim_win_close(win, true)
			end
		end
	else
		-- for _, win in pairs(open_windows) do
		--   print(vim.inspect(vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))))
		--   print(vim.inspect(vim.api.nvim_win_get_config(win)))
		-- end
	end
end

vim.api.nvim_set_keymap("n", "-", "", { silent = true, callback = require("nvim-tree").toggle })

vim.api.nvim_create_autocmd({ "BufEnter" }, { pattern = "*", callback = close_if_last, nested = true })

-- vim.api.nvim_command [[ autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() =~ 'NvimTree_' | quit | endif ]]
