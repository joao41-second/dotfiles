
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- empty setup using defaults

-- OR setup with some options
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})


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

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "javascript", "python", "cpp", "rust" }, -- Adiciona as linguagens que usas
  highlight = {
    enable = true, -- Ativa syntax highlight
  },
  indent = {
    enable = false, -- Melhora a indentação automática
  }
}

require("bufferline").setup({
  options = {
    diagnostics = "nvim_lsp",
    show_buffer_close_icons = false,
    show_close_icon = false,
    separator_style = "slant",
  },
})




