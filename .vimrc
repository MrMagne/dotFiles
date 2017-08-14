"let g:loaded_zipPlugin= 1
"let g:loaded_zip      = 1
filetype off "requied for vundle
try
  "use vundle, run :PluginInstall to after adding new Plugins
  set rtp+=~/.vim/bundle/Vundle.vim
  call vundle#begin()
  " let Vundle manage Vundle, required
  Plugin 'VundleVim/Vundle.vim'
  Plugin 'tikhomirov/vim-glsl'
  Plugin 'kana/vim-operator-user'
  Plugin 'rhysd/vim-clang-format'
  Plugin 'Valloric/YouCompleteMe' "run ''./install.py --clang-completer --tern-completer --racer-completer --gocode-completer'' after update
  Plugin 'leafgarland/typescript-vim'
  Plugin 'powerman/vim-plugin-AnsiEsc'
  Plugin 'scrooloose/nerdtree.git'
  Plugin 'vim-scripts/a.vim'
  Plugin 'tpope/vim-fugitive'
  Plugin 'Matt-Deacalion/vim-systemd-syntax'
  call vundle#end()
endtry

set re=1
set nocp
set cino=:0,l1,N-s,(0,W4,g1
filetype plugin indent on
"set grepprg=grep\ -nH\ $*
set grepprg=rg\ --vimgrep
let g:tex_flavor = "latex"

"helptags ~/.vim/doc
"runtime! ftplugin/man.vim
"nnoremap K :Man <cword><CR>
set undofile
set undodir=~/.vim/undofiles

" re-reads buffers from file if modified outside of vim, rescanning on focus
" gained or bufEnter
set autoread
au FocusGained,BufEnter * :checktime

"source ${VIM}/vimfiles/macros/clewn_mappings.vim
"let s:term = "urxvtc"
"function! ClewnToggle()
"  if(has("netbeans_enabled")) 
"    nbclose
"  else
"    exe "! ".s:term." -e clewn -x \"\""
"    redraw!
"    nbstart :localhost:3219:
"  endif
"endfunction  

"map <F6> :call ClewnToggle()<CR>

"visual bell
set vb

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Don't redraw while executing macros (good performance config)
set lazyredraw

set mouse=a
if !has('nvim')
  set clipboard=unnamed,autoselect,exclude:cons\|linux
  if $TERM == "rxvt-unicode-256color"
    set ttymouse=urxvt
    "map [7^ <Home>
    "map [8^ <End>
    map [7~ <Home>
    map [8~ <End>
    map Oa <C-Up>
    map Ob <C-Down>
    map OC <C-Right>
    map OD <C-Left>
    map [5~ <C-PageUp>
    map [6~ <C-PageDown>
    map [7^ <C-Home>
    map [8^ <C-End>
  "elseif $TERM == "screen"
  "  set ttymouse=xterm2
  else
    set ttymouse=sgr
  endif
endif
"set ttymouse=xterm
"set ttymouse=sgr
set mousefocus
"map ^[Oa <C-Up>
"map ^[Ob <C-Down>
"map ^[Oc <C-Right>
"map ^[Od <C-Left>
"map ^[[5^ <C-PageUp>
"map ^[[6^ <C-PageDown>
"map ^[[7^ <C-Home>
"map ^[[8^ <C-End>
"map [7^ <Home>
"map [8^ <End>
"map [7~ <Home>
"map [8~ <End>

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
noremap <F4> :NERDTreeToggle<CR> 
noremap <F3> :NERDTreeFind<CR>

"alternate
let g:alternateNoDefaultAlternate=1
let g:alternateSearchPath = 'reg:/inc/src/,reg:/Include/Source,reg:/src/inc/,reg:/Source/Include,sfr:../source,sfr:../src,sfr:../include,sfr:../inc'

"set autoindent
"set smartindent
set shiftwidth=2
set softtabstop=2 
set tabstop=2 
set expandtab
syn on
set incsearch
set hlsearch

autocmd FileType c setlocal cindent
autocmd FileType cpp setlocal cindent

"set relativenumber
syntax match Tab /\t/
autocmd ColorScheme * hi Tab guibg=black ctermbg=black
autocmd Syntax * syn match Tab /\t/
colo desert

" diff mode color tweak
highlight DiffAdd term=reverse cterm=bold ctermbg=green ctermfg=white
highlight DiffChange term=reverse cterm=bold ctermbg=lightcyan ctermfg=black
highlight DiffText term=reverse cterm=bold ctermbg=black ctermfg=white
highlight DiffDelete term=reverse cterm=bold ctermbg=red ctermfg=black

highlight Pmenu guibg=black
"doxygen color tweak
hi SpecialComment guifg=SlateBlue
"doxygen syntax highlighting
let g:load_doxygen_syntax=1
hi StatusLine guibg=grey50 guifg=black 
hi StatusLineNC guifg=black 
hi LineNr guibg=black

hi YcmErrorSection ctermfg=black ctermbg=red
"FIXME overridden by filetype syntax
"syntax match Tab /\t/
"hi Tab gui=underline guifg=blue ctermbg=blue

let g:ycm_server_python_interpreter = '/usr/bin/python'
let g:ycm_confirm_extra_conf = 1
let g:ycm_extra_conf_globlist = ['~/projects/*'] 
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
" let g:ycm_extra_conf_vim_data = ['getcwd()']
let g:ycm_auto_trigger = 0
let g:ycm_autoclose_preview_window_after_completion = 1
nnoremap <leader>ja :YcmCompleter GoTo<CR> 
nnoremap <leader>jd :YcmCompleter GoToDeclaration<CR> 
nnoremap <leader>ji :YcmCompleter GoToDefinition<CR> 
nnoremap <leader>jf :YcmCompleter GoToInclude<CR> 
nnoremap <leader>jt :YcmCompleter GetType<CR> 
nnoremap <leader>jr :YcmCompleter RefactorRename 
nnoremap <leader>jk :YcmCompleter FixIt<CR>

" let xml_syntax_folding=1 
"set nofoldenable

"nnoremap <silent> <Leader>f :FufFile<CR>
"nnoremap <silent> <Leader>o :FufCoverageFile<CR>
let g:ackprg = 'ag'
let g:ack_wildignore = 0
set wildmenu "show matches when completing filenames in command-line

let g:clang_format#detect_style_file = 1
" map to <Leader>cf in C++ code
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
" if you install vim-operator-user
autocmd FileType c,cpp,objc map <buffer><Leader>x <Plug>(operator-clang-format)
" Toggle auto formatting:
nmap <Leader>C :ClangFormatAutoToggle<CR>
"map <C-K> :pyf /usr/share/clang/clang-format.py<cr>
"imap <C-K> <c-o>:pyf /usr/share/clang/clang-format.py<cr>


au BufReadCmd *.jar,*.ois,*.iis,*.oisb,*.iisb call zip#Browse(expand("<amatch>"))

