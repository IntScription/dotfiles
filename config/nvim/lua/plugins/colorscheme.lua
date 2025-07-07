return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {
      style = "night", -- available: storm, night, moon, day
      transparent = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
      },
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },
}
