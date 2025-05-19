return {
  {
    "alexghergh/nvim-tmux-navigation",
    config = function()
      require("nvim-tmux-navigation").setup({
        disable_when_zoomed = true, -- prevents navigation when tmux pane is zoomed
      })
    end,
  },
}
