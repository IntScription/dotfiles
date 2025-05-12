local keymap = vim.keymap -- for conciseness

keymap.set("i", "jj", "<ESC>", { desc = "Exit insert mode with jj" })
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- sourcing
keymap.set("n", "<leader>so", "<cmd>source %<CR>", { desc = "Source current file" })
keymap.set("n", "<leader>sO", "<cmd>source $MYVIMRC<CR>", { desc = "Source Neovim config" })

-- saving and quitting
keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" }) -- save
keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" }) -- quit
keymap.set("n", "<leader>qa", "<cmd>q!<CR>", { desc = "Force quit" }) -- force quit without saving
keymap.set("n", "<leader>wq", "<cmd>wq<CR>", { desc = "Save and quit" }) -- save and quit
keymap.set("n", "<leader>wa", "<cmd>wa<CR>", { desc = "Write all buffers" }) -- save all
keymap.set("n", "<leader>wqw", "<cmd>wqa<CR>", { desc = "Save all and quit" }) -- save all and quit

-- split navigation with leader key
keymap.set("n", "<leader>sh", "<C-w>h", { desc = "Move to left split" })
keymap.set("n", "<leader>sj", "<C-w>j", { desc = "Move to below split" })
keymap.set("n", "<leader>sk", "<C-w>k", { desc = "Move to above split" })
keymap.set("n", "<leader>sl", "<C-w>l", { desc = "Move to right split" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "setsv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "sc", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab
