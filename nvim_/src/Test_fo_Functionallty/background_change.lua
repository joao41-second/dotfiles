-- Variável para rastrear se o fundo está transparente ou não
local transparent_enabled = false

-- Função para alternar o fundo transparente
function ToggleTransparency()
  if transparent_enabled then
    -- Se estiver transparente, definir fundo sólido
    vim.cmd [[
      hi Normal guibg=#1E1E1E
      hi NonText guibg=#1E1E1E
      hi LineNr guibg=#1E1E1E
      hi SignColumn guibg=#1E1E1E
    ]]
    transparent_enabled = false
  else
    -- Se não estiver transparente, remover fundo
    vim.cmd [[
      hi Normal guibg=none
      hi NonText guibg=none
      hi LineNr guibg=none
      hi SignColumn guibg=none
    ]]
    transparent_enabled = true
  end
end

-- Mapeia teclas para ativar/desativar o fundo transparente
vim.api.nvim_set_keymap('n', 'tt', ':lua ToggleTransparency()<CR>', { noremap = true, silent = true })
--vim.cmd (":Ex")
--vim.cmd (":vsplit")
-- No seu init.lua
-- Configurações do Telescope
vim.cmd("nnoremap <C-p> :Ntree<CR>")   -- Mapeia Ctrl+p para abrir o buscador de arquivos
vim.cmd("let g:telescope_sorting_strategy = 'ascending'") -- Define a estratégia de ordenação

vim.cmd("colorscheme onedark")

-- Configurações de tema do Base46
