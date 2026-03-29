return {
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      opts.lsp = opts.lsp or {}
      opts.lsp.hover = { enabled = false }
      opts.lsp.signature = { enabled = false }
    end,
  },
}
