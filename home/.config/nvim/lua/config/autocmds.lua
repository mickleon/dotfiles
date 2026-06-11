-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Tabs

vim.api.nvim_create_autocmd("FileType", {
  pattern = "make",
  callback = function()
    vim.opt_local.expandtab = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua", "typst", "html", "htmldjango", "xml", "markdown" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- Wrap

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "tex", "typst" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})

-- Disable conceal im markdown

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "mdx", "quarto" },
  callback = function()
    vim.opt_local.conceallevel = 0
    vim.opt_local.concealcursor = ""
  end,
})

-- Spelling  check

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex", "latex", "typst", "text", "markdown" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "ru,en"
  end,
})
