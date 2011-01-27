" set runtimepath=~/.vim,/var/lib/vim/addons,/usr/share/vim/vimfiles,/usr/share/vim/vim71,/usr/share/vim/vimfiles/after,/var/lib/vim/addons/after,~/.vim/after,/usr/share/vim-scripts/plugin,/usr/share/vim-scripts/after,/usr/share/vim-scripts/autoload,/usr/share/vim-scripts/colors,/usr/share/vim-scripts/doc,/usr/share/vim-scripts/ftplugin,/usr/share/vim-scripts/indent,/usr/share/vim-scripts/macros,/usr/share/vim-scripts/sokoban-levels,/usr/share/vim-scripts/syntax,/usr/share/vim-scripts/vimplate-templates

set nocp
filetype plugin on
"helptags ~/.vim/doc
runtime! ftplugin/man.vim
nnoremap K :Man <cword><CR>

"Tlist settings
let Tlist_Use_Right_Window=1
"let Tlist_Auto_Open = 1
let Tlist_Inc_Winwidth = 0
:noremap <F3> :Tlist<CR> 

"visual bell
set vb

"autocmd FileType c set omnifunc=ccomplete#Complete

"Latex settings
autocmd FileType tex setlocal textwidth=80
autocmd FileType tex setlocal spell
autocmd FileType tex setlocal spelllang=fr

"NERDTree
:noremap <F4> :NERDTreeToggle<CR> 

set autoindent
set smartindent
set shiftwidth=2
set softtabstop=2 
set expandtab
syn on
set incsearch
set hlsearch
colo desert
"doxygen color tweak
hi SpecialComment guifg=SlateBlue

"doxygen syntax highlighting
let g:load_doxygen_syntax=1
"let g:DoxygenToolkit_briefTag_pre=""
"let g:DoxygenToolkit_authorName="Charles Prévot <prevot@cervval.com>"
"let g:DoxygenToolkit_licenseTag="copyright (c) Cervval (http://www.cervval.com)"

"function! SetHeight()
"  if &lines < 62
"    execute "set lines=62"
"    silent! execute "winpos ".&columns." ".0
"  endif
"endfunction
":noremap <F2> :call SetHeight()<CR>
"autocmd GUIEnter * call SetHeight()

set foldmethod=syntax
autocmd BufEnter * exe "normal zR"
"set nofoldenable

set tags=.tags,./.tags,~/.tags,./tags,./TAGS,tags,TAGS
map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q -f .tags .<CR>
imap <expr> <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q -f .tags .<CR>
imap <C-space> <C-X><C-O>

let OmniCpp_MayCompleteDot = 0
let OmniCpp_MayCompleteArrow = 0
let OmniCpp_MayCompleteScope = 0
"close preview tags window
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif


if filereadable("./cscope.out")
  cs add ./cscope.out
endif

map <S-C-F12> :!cscope -Rbq <CR>
imap <expr> <S-C-F12> :!cscope -Rbq <CR>
cnoreabbrev <expr> csa
      \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs add'  : 'csa')
cnoreabbrev <expr> csf
      \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs find' : 'csf')
cnoreabbrev <expr> csk
      \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs kill' : 'csk')
cnoreabbrev <expr> csr
      \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs reset' : 'csr')
cnoreabbrev <expr> css
      \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs show' : 'css')
cnoreabbrev <expr> csh
      \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs help' : 'csh')
