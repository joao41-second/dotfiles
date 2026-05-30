vim.keymap.set("n", "<leader>e", function()
	require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
end, { desc = "Alternar Neo-tree" })

vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")
vim.cmd("highlight NormalNC guibg=NONE ctermbg=NONE")

-- move tabs
vim.api.nvim_set_keymap("n", "<S-l>", "<Cmd>BufferNext<CR>", { desc = "tab  next" })
vim.api.nvim_set_keymap("n", "<S-h>", "<Cmd>BufferPrevious<CR>", { desc = "tab previos" })

vim.api.nvim_set_keymap("n", "<leader>l", "<Cmd>BufferMoveNext<CR>", { desc = "move tab next" })
vim.api.nvim_set_keymap("n", "<leader>h", "<Cmd>BufferMovePrevious<CR>", { desc = "move tab previos" })

-- keymap move in the screan split
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "q", ":bdelete<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "t", ":Chat<CR>", { noremap = true })

-- Atalhos do Telescope
vim.api.nvim_set_keymap("n", "ff", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "fg", ":Telescope live_grep<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "fb", ":Telescope buffers<CR>", { noremap = true, silent = true }) -- Mostra buffers abertos
-- nvim-tree

vim.api.nvim_set_keymap("i", "lk", "<Esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "kl", "<Esc>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("i", "hj", "<Esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "jh", "<Esc>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "kj", "<Esc>", { noremap = true, silent = true })

vim.keymap.set("v", "<leader>c", ":Chat<CR>", { noremap = true })

vim.cmd([[
    autocmd BufRead,BufNewFile *.h set filetype=c
]])

--comment
vim.keymap.set("n", "r", "gcc", { remap = true, desc = "Toggle comentário" })
vim.keymap.set("v", "r", "gc", { remap = true, desc = "Toggle comentário" })
-- Habilita o clipboard do sistema
vim.opt.clipboard = "unnamedplus"

-- Mapeia Ctrl+C para copiar (yank) a seleção visual para o clipboard
vim.keymap.set("v", "<C-c>", '"+y')

-- Mapeia Ctrl+V para colar do clipboard no modo de inserção
vim.keymap.set("i", "<C-v>", "<C-r>+")
vim.keymap.set("c", "<C-v>", "<C-r>+")

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.urdf", "*.xacro" },
	callback = function()
		vim.bo.filetype = "xml"
	end,
})
