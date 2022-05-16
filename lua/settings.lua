local opt = vim.opt

opt.clipboard = "unnamedplus"
opt.encoding = "utf-8"
opt.syntax = "enable"
opt.completeopt = "menuone,noinsert,noselect"

-- Indentation
opt.autoindent = true
opt.expandtab = true
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2

opt.smartcase = true
opt.incsearch = true
opt.wildignore = opt.wildignore + { "*/.git/*" }

-- UI
opt.cursorline = true
opt.list = true
opt.mouse = "a"
opt.number = true
opt.relativenumber = true
opt.wrap = false
opt.timeoutlen = 1000
opt.ttimeoutlen = 1000
opt.updatetime = 250

-- Theme
opt.termguicolors = true
