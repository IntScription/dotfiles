return {
  -- Disable ts-comments so it doesn't conflict
  { "folke/ts-comments.nvim", enabled = false },

  -- Treesitter-powered commentstring support for JSX/TSX/HTML/etc.
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },

  -- Comment.nvim with language-aware commenting
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    opts = function()
      return {
        padding = true,
        sticky = true,
        ignore = "^$",

        toggler = {
          line = "gcc",
          block = "gbc",
        },

        opleader = {
          line = "gc",
          block = "gb",
        },

        extra = {
          above = "gcO",
          below = "gco",
          eol = "gcA",
        },

        mappings = {
          basic = true,
          extra = true,
        },

        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
  },
}
