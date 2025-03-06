
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
end)
