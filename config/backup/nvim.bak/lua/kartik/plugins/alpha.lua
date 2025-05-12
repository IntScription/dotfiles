return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  opts = function()
    local dashboard = require("alpha.themes.dashboard")
    local logo = [[
       ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
       ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    
       ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       
       ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         
       ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
       ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝
       @IntScription
    ]]

    dashboard.section.header.val = vim.split(logo, "\n")
    dashboard.section.footer.val = ""

    -- stylua: ignore
    dashboard.section.buttons.val = {
      dashboard.button("e", " New File", "<cmd>ene<CR>"),
      dashboard.button("SPC e", " Toggle file explorer", "<cmd>NvimTreeToggle<CR>"),
      dashboard.button("SPC ff", " Find File", "<cmd>Telescope find_files<CR>"),
      dashboard.button("SPC fs", " Find Word", "<cmd>Telescope live_grep<CR>"),
      dashboard.button("SPC wr", " Restore Session For Current Directory", "<cmd>SessionRestore<CR>"),
      dashboard.button("c", " Config", function()
        require("telescope.builtin").find_files({
          prompt_title = "Neovim Config Files",
          cwd = vim.fn.stdpath("config"),
          hidden = true,
          file_ignore_patterns = {
            "^.git/",
            "^.github/",
            "^.gitignore$",
            "^.DS_Store$",
            "^.local/share/nvim/lazy/",
          },
        })
      end),
      dashboard.button("l", "" .. " Lazy",            "<cmd> Lazy <cr>"),
      dashboard.button("q", "" .. " Quit",            "<cmd> qa <cr>"),
    }

    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
    end

    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.section.footer.opts.hl = "AlphaFooter"

    -- Center the dashboard with minimal spacing
    dashboard.opts.layout = {
      { type = "padding", val = vim.fn.max({ 1, vim.fn.floor(vim.fn.winheight(0) * 0.1) }) },
      dashboard.section.header,
      { type = "padding", val = 1 },
      dashboard.section.buttons,
      { type = "padding", val = 1 },
      dashboard.section.footer,
    }

    return dashboard
  end,
  config = function(_, dashboard)
    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        callback = function()
          require("lazy").show()
        end,
      })
    end

    require("alpha").setup(dashboard.opts)

    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      callback = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
