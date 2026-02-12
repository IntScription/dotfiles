-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- 🗂️ Tree-style file view
vim.cmd("let g:netrw_liststyle = 3")

-- 🔑 Leader key
vim.g.mapleader = " "

-- 🌐 Encoding
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- 🔢 Line Numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- 📝 Tabs & Indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.breakindent = true

-- 📜 Wrapping
vim.opt.wrap = false

-- 🔍 Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.inccommand = "split"

-- 💡 UI & Cursor
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.showmatch = true
vim.opt.showmode = false
vim.opt.showcmd = true
vim.opt.cmdheight = vim.fn.has("nvim-0.8") == 1 and 0 or 1
vim.opt.laststatus = 3
vim.opt.scrolloff = 10
vim.opt.winbar = "%=%m %f"

-- 🎨 Colors
vim.opt.termguicolors = true
vim.opt.background = "dark"

-- 🔙 Backspace
vim.opt.backspace = { "start", "eol", "indent" }

-- 📋 Clipboard
vim.opt.clipboard:append("unnamedplus")

-- 🪟 Splits
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.splitkeep = "cursor"

-- 🖱️ Mouse (disabled for keyboard-only users; change to 'a' if needed)
vim.opt.mouse = "a"

-- 🧠 Completion Timing
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500

-- 💾 Swap & Undo
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" }

-- 🧭 Shell
vim.opt.shell = "zsh"

-- 🧠 Wildignore & Path
vim.opt.path:append({ "**" })
vim.opt.wildignore:append({ "*/node_modules/*" })

-- 🧙 Persistent Sessions
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- ✨ Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- 🟨 Comment formatting
vim.opt.formatoptions:append({ "r" })

-- 📁 Filetype Detection
vim.cmd([[au BufNewFile,BufRead *.astro setf astro]])
vim.cmd([[au BufNewFile,BufRead Podfile setf ruby]])

vim.filetype.add({
  extension = {
    mdx = "mdx",
  },
})

-- ⚙️ LazyVim globals (optional)
vim.g.lazyvim_prettier_needs_config = true
vim.g.lazyvim_picker = "telescope"
vim.g.lazyvim_cmp = "blink.cmp"
