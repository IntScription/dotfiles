-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- Disable auto comment on new line for all filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove("o")
  end,
})

-- Ensure SCSS files keep proper end of file formatting (fixes --- merging into body)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.scss",
  callback = function()
    vim.opt_local.fixendofline = true
  end,
})

-- Ensure YAML/Jekyll frontmatter stays clean
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.md", "*.markdown", "*.yml", "*.yaml" },
  callback = function()
    vim.cmd([[silent! %s/\s\+$//e]]) -- Remove trailing whitespace
    vim.opt_local.fixendofline = true
  end,
})

-- Auto wrap text properly for markdown, without adding comments
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "md" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
    vim.opt_local.formatoptions:remove("o")
    vim.opt_local.formatoptions:append("t")
  end,
})

-- Restore cursor to last position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

-- General trailing whitespace removal on save (except markdown, handled above)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.lua", "*.vim", "*.js", "*.ts", "*.css", "*.scss", "*.html" },
  callback = function()
    vim.cmd([[silent! %s/\s\+$//e]])
  end,
})
