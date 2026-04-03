return {
  {
    "LazyVim/LazyVim",
    event = "VeryLazy",
    init = function()
      local excluded_filetypes = {
        "help",
        "lazy",
        "mason",
        "neo-tree",
        "NvimTree",
        "Trouble",
        "dashboard",
        "snacks_dashboard",
        "TelescopePrompt",
        "toggleterm",
        "terminal",
        "noice",
        "notify",
      }

      local excluded_buftypes = {
        "terminal",
        "prompt",
        "nofile",
        "quickfix",
      }

      local function is_excluded(buf)
        local ft = vim.bo[buf].filetype
        local bt = vim.bo[buf].buftype
        return vim.tbl_contains(excluded_filetypes, ft) or vim.tbl_contains(excluded_buftypes, bt)
      end

      local function get_relative_path(buf)
        local name = vim.api.nvim_buf_get_name(buf)
        if name == "" then
          return "[No Name]"
        end

        local cwd = vim.loop.cwd()
        local rel = vim.fn.fnamemodify(name, ":.")

        if rel == name and cwd then
          local cwd_escaped = vim.pesc(cwd .. "/")
          rel = name:gsub("^" .. cwd_escaped, "")
        end

        return rel
      end

      local function shorten_path(path, max_len)
        if #path <= max_len then
          return path
        end

        local parts = vim.split(path, "/", { plain = true })
        if #parts <= 1 then
          return path
        end

        local filename = parts[#parts]
        local shortened = filename
        local i = #parts - 1

        while i >= 1 do
          local candidate = parts[i] .. "/" .. shortened
          if #candidate + 2 > max_len then
            break
          end
          shortened = candidate
          i = i - 1
        end

        return "…/" .. shortened
      end

      local function set_winbar()
        local win = vim.api.nvim_get_current_win()
        local buf = vim.api.nvim_win_get_buf(win)

        if is_excluded(buf) then
          vim.wo[win].winbar = ""
          return
        end

        local path = get_relative_path(buf)
        local modified = vim.bo[buf].modified and " [+]" or ""

        local win_width = vim.api.nvim_win_get_width(win)
        local max_len = math.max(20, math.floor(win_width * 0.45))
        local display = shorten_path(path, max_len)

        vim.wo[win].winbar = table.concat({
          "%=",
          "%#WinBar#",
          " ",
          display,
          modified,
          " ",
          "%*",
        })
      end

      local group = vim.api.nvim_create_augroup("simple_path_winbar", { clear = true })

      vim.api.nvim_create_autocmd({
        "BufEnter",
        "BufFilePost",
        "BufModifiedSet",
        "BufWinEnter",
        "DirChanged",
        "FileType",
        "VimResized",
        "WinEnter",
      }, {
        group = group,
        callback = set_winbar,
      })

      vim.schedule(function()
        pcall(set_winbar)
      end)
    end,
  },
}
