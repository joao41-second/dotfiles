vim.keymap.set("n", "<leader>e", function()
  require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
end, { desc = "Alternar Neo-tree" })

vim.opt.background = "dark" 
-- move tabs
vim.api.nvim_set_keymap('n', '<S-l>', '<Cmd>BufferNext<CR>', { desc = "tab  next"})
vim.api.nvim_set_keymap('n', '<S-h>', '<Cmd>BufferPrevious<CR>', { desc = "tab previos"})

vim.api.nvim_set_keymap('n', '<leader>l', '<Cmd>BufferMoveNext<CR>', { desc =  "move tab next"})
vim.api.nvim_set_keymap('n', '<leader>h', '<Cmd>BufferMovePrevious<CR>', { desc = "move tab previos"})


-- keymap move in the screan split 
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>q", ":bdelete<CR>", { noremap = true, silent = true })

-- Atalhos do Telescope
--vim.api.nvim_set_keymap("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true })
--vim.api.nvim_set_keymap("n", "<leader>fg", ":Telescope live_grep<CR>", { noremap = true, silent = true })
--vim.api.nvim_set_keymap("n", "<leader>fb", ":Telescope buffers<CR>", { noremap = true, silent = true }) -- Mostra buffers abertos
-- nvim-tree

vim.api.nvim_set_keymap("i", "lk", "<Esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "kl", "<Esc>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("i", "hj", "<Esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "jh", "<Esc>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "kj", "<Esc>", { noremap = true, silent = true })


vim.cmd [[
    autocmd BufRead,BufNewFile *.h set filetype=c
]]

