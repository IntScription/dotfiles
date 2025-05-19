return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status")

    local colors = {
      blue = "#65D1FF",
      green = "#3EFFDC",
      violet = "#FF61EF",
      yellow = "#FFDA7B",
      red = "#FF4A4A",
      fg = "#c3ccdc",
      bg = "#112638",
      inactive_bg = "#2c3043",
    }

    local my_lualine_theme = {
      normal = {
        a = { fg = colors.bg, bg = colors.blue, gui = "bold" },
        b = { fg = colors.fg, bg = colors.inactive_bg },
        c = { fg = colors.fg, bg = colors.inactive_bg },
      },
      insert = {
        a = { fg = colors.bg, bg = colors.green, gui = "bold" },
        b = { fg = colors.fg, bg = colors.inactive_bg },
      },
      visual = {
        a = { fg = colors.bg, bg = colors.violet, gui = "bold" },
        b = { fg = colors.fg, bg = colors.inactive_bg },
      },
      replace = {
        a = { fg = colors.bg, bg = colors.red, gui = "bold" },
        b = { fg = colors.fg, bg = colors.inactive_bg },
      },
      inactive = {
        a = { fg = colors.fg, bg = colors.inactive_bg, gui = "bold" },
        b = { fg = colors.fg, bg = colors.inactive_bg },
        c = { fg = colors.fg, bg = colors.inactive_bg },
      },
    }

    -- -- Optional Pulse Animation (Commented)
    -- local uv = vim.loop
    -- local pulse_colors = { colors.yellow, colors.red, colors.violet, colors.blue }
    -- local pulse_index = 1
    -- local function set_mode_highlight()
    --   vim.api.nvim_set_hl(0, "LualineModePulse", {
    --     fg = colors.bg,
    --     bg = pulse_colors[pulse_index],
    --     bold = true,
    --   })
    --   pulse_index = (pulse_index % #pulse_colors) + 1
    -- end
    -- local timer = uv.new_timer()
    -- timer:start(
    --   0,
    --   500,
    --   vim.schedule_wrap(function()
    --     set_mode_highlight()
    --   end)
    -- )

    local mode = {
      "mode",
      fmt = function(str)
        return " " .. str
      end,
      -- color = function()
      --   return "LualineModePulse"
      -- end,
    }

    local diff = {
      "diff",
      colored = true,
      symbols = { added = " ", modified = " ", removed = " " },
    }

    local filename = {
      "filename",
      file_status = true,
      path = 0,
    }

    local branch = {
      "branch",
      icon = { "", color = { fg = colors.blue } },
      separator = "|",
    }

    lualine.setup({
      icons_enabled = true,
      options = {
        theme = my_lualine_theme,
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "|", right = "" },
      },
      sections = {
        lualine_a = { mode },
        lualine_b = { branch },
        lualine_c = { diff, filename },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = colors.yellow },
          },
          { "filetype" },
        },
      },
    })
  end,
}
