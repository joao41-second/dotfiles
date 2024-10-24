-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("o", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Atalho para gerar documentação de função
vim.api.nvim_set_keymap("n", "<leader>n", ":Neogen func<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader>p", ":Telescope buffers", { noremap = true, silent = true })
