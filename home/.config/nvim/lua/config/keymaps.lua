-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = LazyVim.safe_keymap_set

map("n", "ш", "i")
map("n", "м", "v")
map("n", "в", "d")
map("n", "вв", "dd")
map("n", "г", "u")
map("n", "<C-к>", "<C-r>")
map("n", "н", "y")
map("n", "Жц", "<cmd>w<cr>")
map("n", "Жй", "<cmd>q<cr>")
map({ "n", "i" }, "<C-ы>", "<cmd>w<cr>")
