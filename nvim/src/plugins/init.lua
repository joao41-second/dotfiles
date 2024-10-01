-- init.lua

-- Execute o Packer na inicialização
-- vim.opt.runtimepath:prepend("./src/plugins/packer.nvim")


-- -- Configure o Packer para gerenciar plugins
-- require('packer').startup(function(use)
--   -- Packer pode gerenciar a si mesmo
--   use 'wbthomason/packer.nvim'
  
--   -- Adicione outros plugins aqui
--   use 'kyazdani42/nvim-tree.lua' -- Gerenciador de arquivos
--   use 'gruvbox-community/gruvbox' -- Tema de cores
-- end)

-- vim.cmd(":PackerInstall")

vim.opt.runtimepath:prepend("./src/plugins/base46")

-- Adiciona o caminho do runtime


-- init.lua

-- Configuração do Packer
-- require('packer').startup(function(use)
--   -- Packer gerenciando a si mesmo

--   -- NvChad para configuração do Neovim
--   use {
--     'NvChad/NvChad',
--     config = function()
--       require('nvchad').setup({
--         -- Adicione suas opções de configuração aqui
--         options = {
--           theme = "gruvbox", -- Altere o tema, se necessário
--         }
--       })
--     end
--   }
  
--   -- Você pode adicionar outros plugins aqui
--   -- use 'tpope/vim-surround'
--   -- use 'nvim-lua/plenary.nvim'
-- end)


-- vim.cmd(":PackerInstall")

