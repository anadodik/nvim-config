local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	use({ "catppuccin/nvim", as = "catppuccin" })

	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
			require("plugins.treesitter")
		end,
	})

	use({
		"kyazdani42/nvim-tree.lua",
		requires = {
			"kyazdani42/nvim-web-devicons", -- optional, for file icon
		},
		config = function()
			require("plugins.nvim-tree")
		end,
	})

	use({
		"folke/which-key.nvim",
		event = "VimEnter",
		config = function()
			require("plugins.which-key").setup()
		end,
	})

	use({
		"rcarriga/nvim-notify",
		event = "VimEnter",
		config = function()
			vim.notify = require("notify")
		end,
	})

	use({
		"goolord/alpha-nvim",
		config = function()
			require("plugins.alpha-nvim")
		end,
	})

	use({
		"Shatur/neovim-session-manager",
		-- as = "session_manager",
		requires = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("plugins.neovim-session-manager")
		end,
	})

	use({
		"nvim-lualine/lualine.nvim",
		requires = {
			"kyazdani42/nvim-web-devicons",
		},
		config = function()
			require("lualine").setup({
				options = {
					globalstatus = true,
				},
			})
		end,
	})

	use({
		"akinsho/bufferline.nvim",
		tag = "v1.2.0",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
				options = {
					offsets = {
						{
							filetype = "NvimTree",
							text = function()
								return vim.fn.getcwd()
							end,
							highlight = "Directory",
							text_align = "left",
						},
					},
				},
			})
			vim.api.nvim_set_keymap("n", "]b", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "[b", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
		end,
	})

	use({
		"famiu/bufdelete.nvim",
		config = function()
			vim.api.nvim_set_keymap("n", "bq", ":Bdelete<CR>", { noremap = true, silent = true })
		end,
	})

	use({
		"neovim/nvim-lspconfig",
		config = function()
			require("plugins.lsp").setup()
		end,
		requires = {
			{ "williamboman/nvim-lsp-installer" },
			{ "ray-x/lsp_signature.nvim" },
			{ "jose-elias-alvarez/null-ls.nvim" },
			{ "onsails/lspkind-nvim" },
		},
		wants = { "cmp-nvim-lsp", "nvim-lsp-installer", "lsp_signature.nvim", "null-ls.nvim" },
		event = "BufWinEnter",
	})

	use({
		"j-hui/fidget.nvim",
		requires = { "neovim/nvim-lspconfig" },
		config = function()
			require("fidget").setup()
		end,
		event = "BufWinEnter",
	})

	use({
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		opt = true,
		config = function()
			require("plugins.cmp").setup()
		end,
		requires = {
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"ray-x/cmp-treesitter",
			-- "saadparwaiz1/cmp_luasnip",
			-- {
			--   "L3MON4D3/LuaSnip",
			--   wants = "friendly-snippets",
			--   config = function()
			--     require("config.luasnip").setup()
			--   end,
			-- },
			-- "rafamadriz/friendly-snippets",
		},
		-- wants = { "LuaSnip" },
	})

	use({
		"folke/trouble.nvim",
		event = "BufReadPre",
		wants = "nvim-web-devicons",
		cmd = { "TroubleToggle", "Trouble" },
		config = function()
			require("trouble").setup({
				use_diagnostic_signs = true,
			})
		end,
	})

	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				run = "make",
			},
		},
		config = function()
			require("telescope").setup({
				pickers = { lsp_definitions = { theme = "dropdown" } },
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							-- even more opts
						}),
					},
				},
			})
		end,
	})

	use({
		"nvim-telescope/telescope-ui-select.nvim",
		-- opt = true,
		requires = {
			"nvim-telescope/telescope.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("telescope").load_extension("ui-select")
		end,
		after = {
			"telescope.nvim",
			"nvim-lspconfig",
		},
	})

	use({
		"gfeiyou/command-center.nvim",
		requires = { "nvim-telescope/telescope.nvim" },
		config = function()
			require("telescope").load_extension("command_center")
		end,
	})

	use({
		"akinsho/toggleterm.nvim",
		requires = {
			"gfeiyou/command-center.nvim",
		},
		config = function()
			require("toggleterm").setup({
				shade_terminals = false,
			})
			function _G.set_terminal_keymaps()
				local opts = { noremap = true }
				vim.api.nvim_buf_set_keymap(0, "t", [[<C-[>]], [[<C-\><C-n>]], opts)
				vim.api.nvim_buf_set_keymap(0, "t", "<C-[>", [[<C-\><C-n>]], opts)
				vim.api.nvim_buf_set_keymap(0, "t", "<Esc>", [[<C-\><C-n>]], opts)
				-- vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
				vim.api.nvim_buf_set_keymap(0, "t", "<C-w>h", [[<C-\><C-n><C-W>h]], opts)
				vim.api.nvim_buf_set_keymap(0, "t", "<C-w>j", [[<C-\><C-n><C-W>j]], opts)
				vim.api.nvim_buf_set_keymap(0, "t", "<C-w>k", [[<C-\><C-n><C-W>k]], opts)
				vim.api.nvim_buf_set_keymap(0, "t", "<C-w>l", [[<C-\><C-n><C-W>l]], opts)
			end
			vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

			local command_center = require("command_center")
			command_center.add({
				{
					description = "Toggle Terminal",
					cmd = "<cmd>ToggleTerm<CR>",
				},
			})
		end,
	})

	use({
		"sindrets/diffview.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("diffview").setup({})
		end,
	})

	use({
		"TimUntersberger/neogit",
		requires = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
		},
		config = function()
			require("neogit").setup({ integrations = { diffview = true } })
		end,
	})

	if packer_bootstrap then
		require("packer").sync()
	end
end)
