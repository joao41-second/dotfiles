" Desabilitar o fundo
highlight Normal guibg=NONE ctermbg=NONE

" Configurações opcionais (remove o fundo de mais elementos)
highlight NonText guibg=NONE ctermbg=NONE
highlight LineNr guibg=NONE ctermbg=NONE
highlight Folded guibg=NONE ctermbg=NONE
highlight EndOfBuffer guibg=NONE ctermbg=NONE
" Abrir o netrw em uma janela lateral automaticamente ao iniciar o Neovim
autocmd VimEnter * if !argc() | :Explore | endif



" Configurações do netrw para melhor visualização
let g:netrw_banner = 0           " Desativa o banner no topo
let g:netrw_liststyle = 3        " Usa estilo de árvore para o explorador
let g:netrw_browse_split = 3    " Usa uma janela para abrir os arquivos
let g:netrw_altv = 1             " Abre o netrw no lado direito
let g:netrw_winsize = 90      " Define a largura do explorador (em % da tela)

" Auto-save sempre que o buffer perder o foco ou o Neovim for desfocado
autocmd FocusLost,InsertLeave * silent! wall

" Auto-save a cada intervalo de tempo (em milissegundos)
set updatetime=1000  " Salva automaticamente após 1 segundo de inatividade
autocmd CursorHold * silent! wall
