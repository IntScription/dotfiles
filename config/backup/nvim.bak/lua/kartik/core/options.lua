-- Netrw tree-style view
vim.cmd("let g:netrw_liststyle = 3")

-- Set <leader> key
vim.g.mapleader = " "

-- OPTIONS
local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- Wrapping
opt.wrap = false

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

-- Cursor & UI
opt.cursorline = true
opt.signcolumn = "yes"
opt.showmatch = true
opt.showmode = false

-- Colors
opt.termguicolors = true
opt.background = "dark"

-- Backspace behavior
opt.backspace = "indent,eol,start"

-- Clipboard
opt.clipboard:append("unnamedplus")

-- Window splits
opt.splitright = true
opt.splitbelow = true

-- Mouse support
opt.mouse = "a"

-- Swap & Undo
opt.swapfile = false
opt.undofile = true

-- Completion speed
opt.updatetime = 300
opt.timeoutlen = 500

-- Persistent sessions
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Winbar (file name and modified flag)
vim.wo.winbar = "%=%m %f"
