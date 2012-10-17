" set runtimepath=~/.vim,/var/lib/vim/addons,/usr/share/vim/vimfiles,/usr/share/vim/vim71,/usr/share/vim/vimfiles/after,/var/lib/vim/addons/after,~/.vim/after,/usr/share/vim-scripts/plugin,/usr/share/vim-scripts/after,/usr/share/vim-scripts/autoload,/usr/share/vim-scripts/colors,/usr/share/vim-scripts/doc,/usr/share/vim-scripts/ftplugin,/usr/share/vim-scripts/indent,/usr/share/vim-scripts/macros,/usr/share/vim-scripts/sokoban-levels,/usr/share/vim-scripts/syntax,/usr/share/vim-scripts/vimplate-templates

set nocp
set cino=N-s,(0,W4,g0
filetype plugin indent on
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
set clipboard=unnamed,autoselect,exclude:cons\|linux

"helptags ~/.vim/doc
runtime! ftplugin/man.vim
nnoremap K :Man <cword><CR>
set undofile
set undodir=~/.vim/undofiles

source ${VIM}/vimfiles/macros/clewn_mappings.vim
let s:term = "urxvtc"
function! ClewnToggle()
  if(has("netbeans_enabled")) 
    nbclose
  else
    exe "! ".s:term." -e clewn -x \"\""
    redraw!
    nbstart :localhost:3219:
  endif
endfunction  

map <F6> :call ClewnToggle()<CR>

"Tlist settings
let Tlist_Compact_Format = 1
let Tlist_Use_Right_Window=1
let Tlist_File_Fold_Auto_Close = 1
let Tlist_Show_Menu = 1
"let Tlist_Auto_Open = 1
let Tlist_Inc_Winwidth = 0
:noremap <F3> :Tlist<CR> 

let g:vimwiki_menu = 'Plugin.Vimwiki' 

"visual bell
set vb

set mouse=a
set mousefocus

"autocmd FileType c set omnifunc=ccomplete#Complete

"Latex settings
autocmd FileType tex setlocal textwidth=80
autocmd FileType tex setlocal spell
autocmd FileType tex setlocal spelllang=fr
autocmd FileType plaintex setlocal textwidth=80
autocmd FileType plaintex setlocal spell
autocmd FileType plaintex setlocal spelllang=fr
autocmd FileType vimwiki setlocal textwidth=80
autocmd FileType vimwiki setlocal spell
autocmd FileType vimwiki setlocal spelllang=fr

"NERDTree
let NERDTreeMouseMode=2
:noremap <F4> :NERDTreeToggle<CR> 
:noremap <S-F4> :NERDTreeFind<CR>

"alternate
let g:alternateNoDefaultAlternate=1
let g:alternateSearchPath = 'reg:/inc/src/,reg:/Include/Source,reg:/src/inc/,reg:/Source/Include,sfr:../source,sfr:../src,sfr:../include,sfr:../inc'

set autoindent
set smartindent
set shiftwidth=2
set softtabstop=2 
set tabstop=2 
set expandtab
syn on
set incsearch
set hlsearch
colo desert
highlight Pmenu guibg=black
"doxygen color tweak
hi SpecialComment guifg=SlateBlue

"doxygen syntax highlighting
let g:load_doxygen_syntax=1

"function! SetHeight()
"  if &lines < 62
"    execute "set lines=62"
"    silent! execute "winpos ".&columns." ".0
"  endif
"endfunction
":noremap <F2> :call SetHeight()<CR>
"autocmd GUIEnter * call SetHeight()

set foldmethod=syntax
autocmd BufRead * exe "normal zR"
"set nofoldenable

"set tags=.tags,./.tags,~/.tags,./tags,./TAGS,tags,TAGS
"map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --sort=foldcase -f .tags .<CR>
"imap <expr> <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --sort=foldcase -f .tags .<CR>
"imap <C-space> <C-X><C-O>

"let OmniCpp_MayCompleteDot = 0
"let OmniCpp_MayCompleteArrow = 0
"let OmniCpp_MayCompleteScope = 0
let clang_library_path='/usr/lib/llvm'
let clang_complete_auto=0
set completeopt=menu,longest

"close preview tags window
"autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
"autocmd InsertLeave * if pumvisible() == 0|pclose|endif


"if filereadable("./cscope.out")
"  cs add ./cscope.out
"endif
"
"function! UpdateCscope()
"  :!cscope -Rbq
"  cscope reset
"endfunction
"
"map <S-C-F12> :call UpdateCscope()<CR>
"imap <expr> <S-C-F12> :call UpdateCscope()<CR>
"map <C-@> :cscope find c <cword><CR>
"
"cnoreabbrev <expr> csa
"      \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs add'  : 'csa')
"cnoreabbrev <expr> csf
"      \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs find' : 'csf')
"cnoreabbrev <expr> csk
"      \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs kill' : 'csk')
"cnoreabbrev <expr> csr
"      \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs reset' : 'csr')
"cnoreabbrev <expr> css
"      \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs show' : 'css')
"cnoreabbrev <expr> csh
"      \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs help' : 'csh')
