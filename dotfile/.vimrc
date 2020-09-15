if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

  Plug 'patstockwell/vim-monokai-tasty'

  Plug 'itchyny/lightline.vim'
  Plug 'vim-airline/vim-airline'
  
  """ Syntax plugins
  Plug 'pangloss/vim-javascript'
  Plug 'MaxMEllon/vim-jsx-pretty'
  Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
  Plug 'elzr/vim-json'
  Plug 'jparise/vim-graphql'
  Plug 'vim-python/python-syntax'

call plug#end()

set encoding=utf-8 " Necessary to show unicode glyphs
set autoread " Auto reload files that are changed outside of vim
set vb t_vb= " Removes annyoing beeps when bad command

syntax on
colorscheme vim-monokai-tasty
set termguicolors
let g:airline_theme='monokai_tasty'                   " airline theme
let g:lightline = { 'colorscheme': 'monokai_tasty' }
let g:python_highlight_all = 1

set mouse=a " Allow mouse-control
set ttymouse=xterm2 " Allow mouse drag 
set cino+=(0 " When in unclosed parens, ie args, have them line up
set cursorline

set number   
set linebreak	
set showbreak=+++
set showmatch	
set visualbell	

set hlsearch	
set smartcase	 
set ignorecase
set incsearch	
  
set autoindent  
set smarttab	
   
set ruler
    
set undolevels=1000	
set backspace=indent,eol,start
set shiftwidth=2 tabstop=2 expandtab

set number relativenumber
let g:netrw_banner = 0 " Remove the banner in the Network Directory 
let g:netrw_liststyle = 3 " Network Directory default to list view 3
let g:netrw_browse_split = 2 " [1-4] Open file in a vertical split(2)
let g:netrw_altv = 1
let g:netrw_winsize = 25 " Set the width of the directory explorer
augroup ProjectDrawer
  autocmd!
  autocmd VimEnter * :Vexplore
augroup END

" Mapping Commands
nmap <s-enter> o<esc>
nnoremap ss i<space><esc>

inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {{     {
inoremap {}     {}

inoremap (      ()<Left>
inoremap (<CR>  (<CR>)<Esc>O
inoremap ((     (
inoremap ()     ()
