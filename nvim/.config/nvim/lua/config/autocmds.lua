-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Disable auto comment on new line for all filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove("o")
  end,
})

-- Markdown settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
    vim.opt_local.formatoptions:remove("o")
    vim.opt_local.formatoptions:append("t")
  end,
})

-- Ensure SCSS files keep proper end-of-file formatting
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.scss",
  callback = function()
    vim.opt_local.fixendofline = true
  end,
})

-- Clean markdown/yaml before save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.md", "*.markdown", "*.yml", "*.yaml" },
  callback = function()
    vim.cmd([[silent! %s/\s\+$//e]])
    vim.opt_local.fixendofline = true
  end,
})

-- General trailing whitespace removal on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.lua", "*.vim", "*.js", "*.ts", "*.css", "*.scss", "*.html" },
  callback = function()
    vim.cmd([[silent! %s/\s\+$//e]])
  end,
})

-- Auto-fix Markdown with markdownlint on save for files inside the dotfiles repo
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.md", "*.markdown" },
  callback = function(args)
    local filepath = args.match
    local root = vim.fn.expand("~/dotfiles/")
    if filepath:sub(1, #root) == root then
      local fix_script = root .. "scripts/fix_markdown.sh"
      if vim.fn.filereadable(fix_script) == 1 then
        vim.fn.jobstart({ fix_script, filepath }, {
          detach = true,
          on_exit = function()
            if vim.api.nvim_buf_is_loaded(0) then
              vim.schedule(function()
                vim.cmd("checktime")
              end)
            end
          end,
        })
      end
    end
  end,
})

-- Restore cursor to last position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
