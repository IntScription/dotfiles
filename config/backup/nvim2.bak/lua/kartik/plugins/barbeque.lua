return {
  "utilyre/barbecue.nvim",
  name = "barbecue",
  version = "*",
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- for file icons
    "SmiteshP/nvim-navic", -- for breadcrumb functionality
  },
  opts = {
    attach_navic = true, -- Enable navic integration
    show_modified = true,
    theme = "auto",
  },
  config = function(_, opts)
    require("barbecue").setup(opts)
  end,
}
