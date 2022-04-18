local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
end

return require("packer").startup(function(use)
  use "wbthomason/packer.nvim"
  use { "catppuccin/nvim", as = "catppuccin" }

  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function() require "plugins.treesitter" end
  }

  use {
    "kyazdani42/nvim-tree.lua",
    requires = {
      "kyazdani42/nvim-web-devicons", -- optional, for file icon
    },
    config = function() require "plugins.nvim-tree" end
  }

  use {
    "nvim-telescope/telescope.nvim",
    requires = {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make",
      },
    },
    config = function() require('telescope').setup({
        pickers = { lsp_definitions = { theme = "dropdown" } },
      })
    end
  }

  use {
    "folke/which-key.nvim",
    event = "VimEnter",
    config = function() require("plugins.which-key").setup() end,
  }

  use {
    "rcarriga/nvim-notify",
    event = "VimEnter",
    config = function() vim.notify = require "notify" end,
  }

  use {
    "goolord/alpha-nvim",
    config = function() require "plugins.alpha-nvim" end
  }

  use {
    "Shatur/neovim-session-manager",
    -- as = "session_manager",
    requires = {
      "nvim-lua/plenary.nvim"
    },
    config = function() require "plugins.neovim-session-manager" end
  }

  use {
    "nvim-lualine/lualine.nvim",
    requires = {
      "kyazdani42/nvim-web-devicons",
    },
    config = function() require("lualine").setup() end
  }

  use({
    "neovim/nvim-lspconfig",
    config = function() require("plugins.lsp").setup() end,
    requires = {
      { "williamboman/nvim-lsp-installer" },
      { "ray-x/lsp_signature.nvim" },
      { "jose-elias-alvarez/null-ls.nvim" },
    },
    wants = { "cmp-nvim-lsp", "nvim-lsp-installer", "lsp_signature.nvim", "null-ls.nvim" },
    event = "BufWinEnter",
  })

  use({
    "onsails/lspkind-nvim",
  })

  use {
    "j-hui/fidget.nvim",
    config = function() require("fidget").setup() end
  }

  use {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    opt = true,
    config = function()
      require("plugins.cmp").setup()
    end,
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "ray-x/cmp-treesitter",
      "onsails/lspkind-nvim",
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
  }

  use {
    "folke/trouble.nvim",
    event = "BufReadPre",
    wants = "nvim-web-devicons",
    cmd = { "TroubleToggle", "Trouble" },
    config = function()
      require("trouble").setup {
        use_diagnostic_signs = true,
      }
    end,
  }

  use {
    "gfeiyou/command-center.nvim",
    requires = { "nvim-telescope/telescope.nvim" },
    config = function() require("telescope").load_extension('command_center') end,
  }

  -- use {
  --   'mrjones2014/legendary.nvim',
  --   config = function()
  --     require("legendary").setup {
  --       include_builtin = false,
  --       auto_register_which_key = false,
  --     }
  --   end,
  -- }

  use {
    'stevearc/dressing.nvim',
    config = function()
      require("dressing").setup {
        select = {
          enabled = true,
          backend = { "telescope" },
          telescope = require('telescope.themes').get_dropdown({}),
        },
      }
    end,
  }

  if packer_bootstrap then
    require("packer").sync()
  end
end)
