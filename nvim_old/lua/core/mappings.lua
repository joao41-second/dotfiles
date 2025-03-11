local keymap = vim.keymap

vim.keymap.set("o", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
