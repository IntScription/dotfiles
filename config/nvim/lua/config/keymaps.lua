-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap -- for conciseness

keymap.set("i", "jj", "<ESC>", { desc = "Exit insert mode with jj" })
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- sourcing
keymap.set("n", "<leader>so", "<cmd>source %<CR>", { desc = "Source current file" })
keymap.set("n", "<leader>sO", "<cmd>source $MYVIMRC<CR>", { desc = "Source Neovim config" })

-- Save file
keymap.set("n", "<leader>W", "<cmd>w<CR>", { desc = "󰆓 Save file" })

-- Quit current window
keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = " Quit window" })

-- Force quit (without saving)
keymap.set("n", "<leader>Q", "<cmd>q!<CR>", { desc = " Force quit" })

-- split navigation with leader key
keymap.set("n", "<leader>h", "<C-w>h", { desc = "Move to left split" })
keymap.set("n", "<leader>j", "<C-w>j", { desc = "Move to below split" })
keymap.set("n", "<leader>k", "<C-w>k", { desc = "Move to above split" })
keymap.set("n", "<leader>l", "<C-w>l", { desc = "Move to right split" })

-- window management
keymap.set("n", "sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "sc", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window
