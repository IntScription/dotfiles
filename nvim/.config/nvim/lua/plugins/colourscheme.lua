return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = true,
      terminal_colors = true,

      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = { bold = false },
        variables = {},
        sidebars = "transparent",
        floats = "transparent",
      },

      on_highlights = function(hl, c)
        hl.Normal = { bg = "NONE" }
        hl.NormalNC = { bg = "NONE" }
        hl.NormalFloat = { bg = "NONE" }
        hl.FloatBorder = { fg = c.blue, bg = "NONE" }

        hl.SignColumn = { bg = "NONE" }
        hl.LineNr = { fg = c.dark5, bg = "NONE" }
        hl.CursorLineNr = { fg = c.yellow, bold = true }

        hl.VertSplit = { fg = c.dark3, bg = "NONE" }
        hl.WinSeparator = { fg = c.dark3, bg = "NONE" }

        hl.StatusLine = { bg = "NONE" }
        hl.StatusLineNC = { bg = "NONE" }

        hl.NeoTreeNormal = { bg = "NONE" }
        hl.NeoTreeNormalNC = { bg = "NONE" }
        hl.NeoTreeEndOfBuffer = { bg = "NONE" }

        hl.TelescopeNormal = { bg = "NONE" }
        hl.TelescopeBorder = { fg = c.blue, bg = "NONE" }
        hl.TelescopePromptNormal = { bg = "NONE" }
        hl.TelescopePromptBorder = { fg = c.blue, bg = "NONE" }
        hl.TelescopeResultsNormal = { bg = "NONE" }
        hl.TelescopeResultsBorder = { fg = c.dark3, bg = "NONE" }
        hl.TelescopePreviewNormal = { bg = "NONE" }
        hl.TelescopePreviewBorder = { fg = c.dark3, bg = "NONE" }

        hl.Pmenu = { bg = c.bg_dark, fg = c.fg }
        hl.PmenuSel = { bg = c.blue, fg = c.black }

        hl.Visual = { bg = c.bg_highlight }
        hl.Search = { bg = c.orange, fg = c.black }
        hl.IncSearch = { bg = c.yellow, fg = c.black }

        hl.WinBar = { bg = "NONE" }
        hl.WinBarNC = { bg = "NONE" }
      end,
    },

    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },
}
