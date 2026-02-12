return {
  -- Disable ts-comments so it doesn't conflict
  { "folke/ts-comments.nvim", enabled = false },

  -- Add Comment.nvim
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function()
      require("Comment").setup()
    end,
  },
}
