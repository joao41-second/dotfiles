" Desabilitar o fundo
highlight Normal guibg=NONE ctermbg=NONE

" Configurações opcionais (remove o fundo de mais elementos)
highlight NonText guibg=NONE ctermbg=NONE
highlight LineNr guibg=NONE ctermbg=NONE
highlight Folded guibg=NONE ctermbg=NONE
highlight EndOfBuffer guibg=NONE ctermbg=NONE


" Configurações básicas do Neovim
set nocompatible              " Modo compatível desativado
set backspace=indent,eol,start " Permitir backspace em várias situações
set clipboard=unnamedplus     " Usar clipboard do sistema

" Habilitar número de linha
set number

" Definir o comando para abrir o explorer
command! OpenExplorer :vsplit | :Ex

" Mapeamento de teclas para abrir o explorer
nnoremap   po :OpenExplorer<CR>




set termguicolors             " Habilitar cores de terminal
syntax on                     " Habilitar destaque de sintaxe


let g:netrw_browse_split = 3       " Abre os arquivos em janelas verticais, mantendo o netrw"

" Auto-save sempre que o buffer perder o foco ou o Neovim for desfocado
autocmd FocusLost,InsertLeave * silent! wall

" Auto-save a cada intervalo de tempo (em milissegundos)
set updatetime=1000  " Salva automaticamente após 1 segundo de inatividade
autocmd CursorHold * silent! wall
