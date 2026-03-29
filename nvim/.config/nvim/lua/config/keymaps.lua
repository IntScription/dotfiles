-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local keymap = vim.keymap

-- Insert mode escapes
keymap.set("i", "jj", "<ESC>", { desc = "Exit insert mode with jj" })
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- Source files
keymap.set("n", "<leader>so", "<cmd>source %<CR>", { desc = "Source current file" })
keymap.set("n", "<leader>sO", "<cmd>source $MYVIMRC<CR>", { desc = "Source Neovim config" })

-- Save
keymap.set("n", "<leader>W", "<cmd>w<CR>", { desc = "Save file" })

-- split navigation with leader key
keymap.set("n", "<leader>h", "<C-w>h", { desc = "Move to left split" })
keymap.set("n", "<leader>j", "<C-w>j", { desc = "Move to below split" })
keymap.set("n", "<leader>k", "<C-w>k", { desc = "Move to above split" })
keymap.set("n", "<leader>l", "<C-w>l", { desc = "Move to right split" })

-- Window management
keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split vertically" })
keymap.set("n", "<leader>wh", "<C-w>s", { desc = "Split horizontally" })
keymap.set("n", "<leader>we", "<C-w>=", { desc = "Equalize splits" })
keymap.set("n", "<leader>wc", "<cmd>close<CR>", { desc = "Close split" })
keymap.set("n", "<leader>wd", "<cmd>q<CR>", { desc = "Close window" })
keymap.set("n", "<leader>wD", "<cmd>q!<CR>", { desc = "Force close window" })
