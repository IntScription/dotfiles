return {
  "christoomey/vim-tmux-navigator",
  lazy = false, -- important so keymaps always work
  keys = {
    { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Go to left pane" },
    { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Go to down pane" },
    { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Go to up pane" },
    { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Go to right pane" },
    { "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Go to previous pane" },
  },
}
