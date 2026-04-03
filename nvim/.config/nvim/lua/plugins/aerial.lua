return {
  {
    "stevearc/aerial.nvim",
    opts = {
      layout = {
        max_width = 28,
        min_width = 20,
        default_direction = "right",
      },
      attach_mode = "window",
      close_on_select = true,
      highlight_on_hover = true,
      show_guides = true,
      guides = {
        mid_item = "├─",
        last_item = "└─",
        nested_top = "│ ",
        whitespace = "  ",
      },
    },
    keys = {
      { "<leader>cs", "<cmd>AerialToggle!<CR>", desc = "Code Structure" },
      { "]a", "<cmd>AerialNext<CR>", desc = "Next Symbol" },
      { "[a", "<cmd>AerialPrev<CR>", desc = "Prev Symbol" },
    },
  },
}
