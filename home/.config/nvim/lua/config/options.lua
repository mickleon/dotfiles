-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.clipboard = "unnamedplus"

vim.opt.spelllang = { "ru", "en" }

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.g.vimtex_syntax_conceal_disable = 1

local listchars_current = vim.opt.listchars:get()
local listchars_new = {
  trail = "·",
  nbsp = "␣",
  extends = "»",
  precedes = "«",
}
for character, symbol in pairs(listchars_new) do
  listchars_current[character] = symbol
end
vim.opt.listchars = listchars_current

vim.g.ai_cmp = false

-- vim.g.autoformat = false
