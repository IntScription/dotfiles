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
        local transparent = "NONE"

        -- Shared surface colors
        local sidebar_bg = c.bg_dark
        local float_bg = c.bg_dark1 or c.bg_dark
        local popup_bg = c.bg_dark
        local selection_bg = c.bg_highlight
        local subtle_border = c.dark3
        local strong_border = c.blue

        -- Fallback-safe diagnostic colors
        local error = c.error or "#db4b4b"
        local warning = c.warning or c.orange
        local info = c.info or c.blue
        local hint = c.hint or c.teal or c.cyan

        -- Core editor
        hl.Normal = { bg = transparent }
        hl.NormalNC = { bg = transparent }
        hl.SignColumn = { bg = transparent }
        hl.EndOfBuffer = { fg = c.bg_dark, bg = transparent }

        hl.LineNr = { fg = c.dark5, bg = transparent }
        hl.CursorLineNr = { fg = c.yellow, bg = transparent, bold = true }
        hl.CursorLine = { bg = c.bg_dark }
        hl.CursorColumn = { bg = selection_bg }
        hl.ColorColumn = { bg = c.bg_dark }

        -- Splits / separators
        hl.VertSplit = { fg = subtle_border, bg = transparent }
        hl.WinSeparator = { fg = subtle_border, bg = transparent }

        -- Statusline / winbar
        hl.StatusLine = { bg = transparent }
        hl.StatusLineNC = { bg = transparent }
        hl.WinBar = { bg = transparent }
        hl.WinBarNC = { bg = transparent }

        -- Floats
        hl.NormalFloat = { bg = float_bg }
        hl.FloatBorder = { fg = strong_border, bg = float_bg }
        hl.FloatTitle = { fg = c.cyan, bg = float_bg, bold = true }

        -- Popup menu / completion
        hl.Pmenu = { bg = popup_bg, fg = c.fg }
        hl.PmenuSel = { bg = c.blue, fg = c.black, bold = true }
        hl.PmenuSbar = { bg = c.bg_dark }
        hl.PmenuThumb = { bg = c.dark3 }

        -- Search / selection
        hl.Visual = { bg = c.bg_visual or selection_bg }
        hl.Search = { bg = c.orange, fg = c.black, bold = true }
        hl.IncSearch = { bg = c.yellow, fg = c.black, bold = true }
        hl.CurSearch = { bg = c.yellow, fg = c.black, bold = true }
        hl.MatchParen = { bg = c.bg_highlight, bold = true }

        -- Folds
        hl.Folded = { bg = c.bg_dark, fg = c.dark5 }
        hl.FoldColumn = { bg = transparent }

        -- Diff
        hl.DiffAdd = { bg = "#20303b" }
        hl.DiffChange = { bg = "#1f2233" }
        hl.DiffDelete = { bg = "#37222c" }
        hl.DiffText = { bg = "#394b70" }

        -- Neo-tree panel look
        hl.NeoTreeNormal = { bg = sidebar_bg }
        hl.NeoTreeNormalNC = { bg = sidebar_bg }
        hl.NeoTreeEndOfBuffer = { bg = sidebar_bg }
        hl.NeoTreeWinSeparator = { fg = subtle_border, bg = sidebar_bg }
        hl.NeoTreeCursorLine = { bg = selection_bg }
        hl.NeoTreeFloatNormal = { bg = float_bg }
        hl.NeoTreeFloatBorder = { fg = strong_border, bg = float_bg }
        hl.NeoTreeTitleBar = { fg = c.black, bg = c.blue, bold = true }
        hl.NeoTreeDirectoryName = { fg = c.cyan }
        hl.NeoTreeFileNameOpened = { fg = c.blue, bold = true }

        -- Telescope
        hl.TelescopeNormal = { bg = float_bg }
        hl.TelescopeBorder = { fg = strong_border, bg = float_bg }
        hl.TelescopePromptNormal = { bg = float_bg }
        hl.TelescopePromptBorder = { fg = strong_border, bg = float_bg }
        hl.TelescopeResultsNormal = { bg = float_bg }
        hl.TelescopeResultsBorder = { fg = subtle_border, bg = float_bg }
        hl.TelescopePreviewNormal = { bg = float_bg }
        hl.TelescopePreviewBorder = { fg = subtle_border, bg = float_bg }
        hl.TelescopeTitle = { fg = c.black, bg = c.blue, bold = true }

        -- Diagnostics
        hl.DiagnosticVirtualTextError = { fg = error, bg = transparent }
        hl.DiagnosticVirtualTextWarn = { fg = warning, bg = transparent }
        hl.DiagnosticVirtualTextInfo = { fg = info, bg = transparent }
        hl.DiagnosticVirtualTextHint = { fg = hint, bg = transparent }

        hl.DiagnosticUnderlineError = { undercurl = true, sp = error }
        hl.DiagnosticUnderlineWarn = { undercurl = true, sp = warning }
        hl.DiagnosticUnderlineInfo = { undercurl = true, sp = info }
        hl.DiagnosticUnderlineHint = { undercurl = true, sp = hint }

        -- Git signs
        hl.GitSignsAdd = { fg = c.green, bg = transparent }
        hl.GitSignsChange = { fg = c.yellow, bg = transparent }
        hl.GitSignsDelete = { fg = c.red, bg = transparent }

        -- Lazy / Mason / plugin panels
        hl.LazyNormal = { bg = float_bg }
        hl.LazyBorder = { fg = strong_border, bg = float_bg }
        hl.MasonNormal = { bg = float_bg }
        hl.MasonBorder = { fg = strong_border, bg = float_bg }

        -- Markdown polish
        hl.MarkdownCode = { fg = c.orange }
        hl.MarkdownH1 = { fg = c.blue, bold = true }
        hl.MarkdownH2 = { fg = c.cyan, bold = true }

        -- Optional render-markdown style groups
        hl.RenderMarkdownCode = { bg = c.bg_dark }
        hl.RenderMarkdownCodeInline = { bg = c.bg_dark, fg = c.orange }

        -- Indent guides
        hl.IndentBlanklineChar = { fg = c.dark3 }
        hl.IndentBlanklineContextChar = { fg = c.blue }
      end,
    },

    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },
}
