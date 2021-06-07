if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

  Plug 'morhetz/gruvbox'
  Plug 'itchyny/lightline.vim'
  Plug 'vim-airline/vim-airline'
  
  """ Syntax plugins
  Plug 'dense-analysis/ale'
  Plug 'yuezk/vim-js'
  Plug 'maxmellon/vim-jsx-pretty'

  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'preservim/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'airblade/vim-gitgutter'
  Plug 'mg979/vim-visual-multi', { 'branch': 'master' }
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-fugitive'

call plug#end()


"=================== Theme ===================" 
syntax on
colorscheme gruvbox
set background=dark
set termguicolors
set ttymouse=xterm2 " Allow mouse drag 
if !has('gui_running')
  set t_Co=256
endif
set noshowmode

"=================== Search ===================" 
set hlsearch " Highlight the search
set ignorecase
set smartcase " Switch to case-sensitive when query contains an uppercase letter	 
set incsearch " Incremental search that shows partial matches
  
"=================== Indention ===================" 
set autoindent " New lines inherit the indentation of previous lines 
set smarttab " Insert mode press tab to indent	
   
"=================== Performance ===================" 
set complete-=i " Limit the files searched for auto-completes
set lazyredraw " Do not update screen during macro and script execution

"=================== Text Rendering ===================" 
set display+=lastline " Try to show a paragraph's last line
set encoding=utf-8 " Necessary to show unicode glyphs
set linebreak	

"=================== User Interface ===================" 
set ruler
set mouse=a " Allow mouse-control
set cursorline
set number relativenumber
set cino+=(0 " When in unclosed parens, ie args, have them line up
set showmatch	
set showbreak=+++
set title
set list
set listchars=tab:>-
    
"=================== Miscellaneous ===================" 
set undolevels=1000	
set backspace=indent,eol,start
set shiftwidth=2 tabstop=2 expandtab
set autoread " Auto reload files that are changed outside of vim
set vb t_vb= " Removes annyoing beeps when bad command
set noswapfile " Disable creating .swp files
set laststatus=2

"=================== NERDTree ===================" 
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeShowHidden = 1
let g:NERDTreeGitStatusConcealBrackets = 1
let g:NERDTreeWinSize = 30
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


"=================== netrw ===================" 
let g:netrw_banner = 0
let g:netew_liststyle =3
let g:netrw_browse_split = 2
let g:netrw_altv = 1
let g:netrw_winsize = 25
" augroup ProjectDrawer
"   autocmd!
"   autocmd VimEnter * :Vexplore
" augroup END

" Refresh Vim buffers on git changes
set autoread
autocmd FocusGained * checktime

"=================== fzf ===================" 
"let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'
map ; :GFiles<CR>


" Auto Commands
autocmd VimResized * wincmd =

" Mapping Commands
nmap <F1> :NERDTreeToggle<CR>
nmap <C-S> :w<CR>

command Wq wq
command WQ wq
command W w
command Q q

nmap <s-enter> o<esc>
nnoremap ss i<space><esc>

inoremap <      <><Left>
inoremap <<CR>  <<CR><<Esc>O
inoremap <<     <
inoremap <>     <>

inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {{     {
inoremap {}     {}

inoremap (      ()<Left>
inoremap (<CR>  (<CR>)<Esc>O
inoremap ((     (
inoremap ()     ()

inoremap [      []<Left>
inoremap [<CR>  [<CR>]<Esc>O
inoremap [[     [
inoremap []     []

inoremap "      ""<Left>
inoremap "<CR>  "<CR>"<Esc>O
inoremap ""     "
