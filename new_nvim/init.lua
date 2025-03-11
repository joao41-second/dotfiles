
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

  use 
  {
	 "akinsho/bufferline.nvim",
	 requires = "nvim-tree/nvim-web-devicons"
  }
 --use 'morhetz/gruvbox'  -- Tema popular para Neovim
  use 'folke/tokyonight.nvim'  -- Tema azul escuro

  use 'nvim-lualine/lualine.nvim'  -- Barra de status bonita e customizável
-- inport mansion
use {
  'hrsh7th/nvim-cmp',
  requires = {
    'hrsh7th/cmp-nvim-lsp',   -- LSP completions
    'hrsh7th/cmp-buffer',      -- Completions do buffer
    'hrsh7th/cmp-path',        -- Completions de caminhos
    'hrsh7th/cmp-cmdline',     -- Completions na linha de comando
    'L3MON4D3/LuaSnip',        -- Snippets engine
    'saadparwaiz1/cmp_luasnip' -- Snippets completions
  },
  config = function()
    local cmp = require('cmp')
    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),  -- Ativar autocompletar manualmente
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Aceitar sugestão
        ['<Tab>'] = cmp.mapping.select_next_item(), -- Ir para a próxima sugestão
        ['<S-Tab>'] = cmp.mapping.select_prev_item(), -- Ir para a sugestão anterior
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' }, -- Sugestões do LSP
        { name = 'luasnip' },  -- Snippets
      }, {
        { name = 'buffer' },   -- Sugestões do buffer atual
        { name = 'path' },     -- Sugestões de caminhos de ficheiros
      })
    })
  end
}

use {
  "williamboman/mason.nvim",
  config = function()
    require("mason").setup()
  end
}

  use 'nvim-treesitter/nvim-treesitter' -- Syntax Highlight avançado


end)


require("config/configs")
--require("config/lsp_config")
require("keybind/key_bind")




