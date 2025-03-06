
vim.g.mapleader = " "

local ensure_packer = function()
  local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.api.nvim_command("!git clone --depth 1 https://github.com/wbthomason/packer.nvim " .. install_path)
    vim.api.nvim_command("packadd packer.nvim")
  end
end

-- Chama a função para garantir que o Packer está instalado
ensure_packer()

require('packer').startup(function(use)

  use 'wbthomason/packer.nvim' -- Packer pode gerenciar a si próprio
  use 'jbyuki/monolithic.nvim'
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- Ícones opcionais
    },
    config = function()
      require("nvim-tree").setup()
    end
  }

  use {
    "nvim-telescope/telescope.nvim",
    requires = { "nvim-lua/plenary.nvim" }
  }

  use {
	 "akinsho/bufferline.nvim",
	  requires = "nvim-tree/nvim-web-devicons"
	}


 --use 'morhetz/gruvbox'  -- Tema popular para Neovim
 use 'folke/tokyonight.nvim'  -- Tema azul escuro

 use 'nvim-lualine/lualine.nvim'  -- Barra de status bonita e customizável


end)


require("telescope").setup({
  pickers = {
    buffers = {
      sort_mru = true, -- Ordena pelos mais recentemente usados
      ignore_current_buffer = true, -- Evita mostrar o buffer atual
      mappings = {
        i = { ["<c-x>"] = "delete_buffer" }, -- Ctrl + X fecha buffer
      },
    },
  },
})

-- config  multi file leve
require("bufferline").setup({
  options = {
    diagnostics = "nvim_lsp",
    show_buffer_close_icons = false,
    show_close_icon = false,
    separator_style = "slant",
  },
})

require('lualine').setup({
  options = {
    theme = 'tokyonight',  -- Usa o tema gruvbox na barra de status também
    section_separators = {'', ''},
    component_separators = {'', ''},
  },
  sections = {
    lualine_a = {'mode'},  -- Mostra o modo atual (normal, insert, etc.)
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'filetype'},
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {'fugitive'}
})



-- defenir o tema do nvim 
vim.cmd("colorscheme tokyonight")  -- Define o tema gruvbox
vim.opt.background = "dark"  -- Ou "light" dependendo da tua preferência

-- keymap  multi file level
vim.api.nvim_set_keymap("n", "<S-h>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-l>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
-- keymap move in the screan split 
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>q", ":bdelete<CR>", { noremap = true, silent = true })



-- Atalhos do Telescope
vim.api.nvim_set_keymap("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fg", ":Telescope live_grep<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fb", ":Telescope buffers<CR>", { noremap = true, silent = true }) -- Mostra buffers abertos
-- nvim-tree
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })


require("bufferline").setup({
  options = {
    diagnostics = "nvim_lsp",
    show_buffer_close_icons = false,
    show_close_icon = false,
    separator_style = "slant",
  },
})


