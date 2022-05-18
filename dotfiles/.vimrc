if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl  -fLo ~/.vim/autoload/plug.vim --create-dirs
	\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
  Plug 'dracula/vim', {'name':'dracula'}
  Plug 'sheerun/vim-polyglot'
  Plug 'itchyny/lightline.vim'
  Plug 'vim-airline/vim-airline'
  
  """ Syntax plugins
  Plug 'dense-analysis/ale'
  Plug 'yuezk/vim-js'
  Plug 'maxmellon/vim-jsx-pretty'
  Plug 'leafgarland/typescript-vim'
  Plug 'peitalin/vim-jsx-typescript'

  Plug 'junegunn/fzf', { 'do': { -> fzf#install() }}
  Plug 'junegunn/fzf.vim'
  Plug 'preservim/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'airblade/vim-gitgutter'
  Plug 'mg979/vim-visual-multi'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-fugitive'

  """ Adnvace plugins
  Plug 'itchyny/calendar.vim'
  Plug 'blindFS/vim-taskwarrior'
  Plug 'ledger/vim-ledger'

call plug#end()

"=================== Vim Ledger ===================" 
let g:ledger_fillstring = '    -'
let g:ledger_fold_blanks = 0
autocmd Filetype ledger setlocal nowrap

"=================== General ===================" 
set nocompatible
filetype on
filetype plugin on
filetype indent on
"let &t_ut=''
set modeline
set modelines=5

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
" set lazyredraw " Do not update screen during macro and script execution

"=================== Text Rendering ===================" 
set display+=lastline " Try to show a paragraph's last line
set encoding=utf-8 " Necessary to show unicode glyphs
set breakindent
set formatoptions=l
set lbr
let &showbreak='↳ '
set wrap
set formatlistpat=^\\s*\\*\\+\\s

"=================== User Interface ===================" 
set ruler
set mouse=a " Allow mouse-control
set number relativenumber
set cino+=(0 " When in unclosed parens, ie args, have them line up
set showmatch
set title
set list
set listchars=tab:>-
set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
    
"=================== Undo Backup =========================" 
set undodir=~/.vim/backup
set undofile
set undoreload=10000

"=================== Miscellaneous ===================" 
set autochdir
set undolevels=1000	
set backspace=indent,eol,start
" set shiftwidth=2 tabstop=2 expandtab
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

" Refresh Vim buffers on git changes
set autoread
autocmd FocusGained * checktime

"=================== fzf ===================" 
map ; :GFiles<CR> 

"==================  Mapping Commands ======" 
let mapleader = '\'
nnoremap <leader>\ :nohlsearch<CR>

" Press the space bar to type the : character in command mode.
nnoremap <space> :

" Yank from cursor to the end of line.
nnoremap Y y$

nmap <F1> :NERDTreeToggle<CR>:wincmd =<CR>

command Wq wq
command WQ wq
command W w
command Q q

nmap <s-enter> o<esc>
nnoremap ss i<space><esc>

" Resize split windows using arrow keys by pressing:
" CTRL+UP, CTRL+DOWN, CTRL+LEFT, or CTRL+RIGHT.
noremap <c-up> <c-w>+
noremap <c-down> <c-w>-
noremap <c-left> <c-w>>
noremap <c-right> <c-w><

" Improve Navigation
nmap j gj
nmap k gk
nmap H ^
nmap L $
nnoremap <S-Up> :m-2<CR>
nnoremap <S-Down> :m+<CR>
inoremap <S-Up> <Esc>:m-2<CR>
inoremap <S-Down> <Esc>:m+<CR>

" Yank to system clipboard
set clipboard=unnamed

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

" Custom Commands
:command! -nargs=1 Silent execute ':silent !'.<q-args> | execute ':redraw!'

"=================== Theme ===================" 
syntax on
"""set termguicolors
set background=dark
let g:dracula_italic = 0
let g:dracula_colorterm = 0
"""let g:onedark_hide_endofbuffer=1
"""let g:airline_theme='onedark'

set cursorline
set cursorlineopt=both
set cursorcolumn
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
autocmd WinEnter * setlocal cursorcolumn
autocmd WinLeave * setlocal nocursorcolumn
augroup colorextend
 autocmd!
""" autocmd ColorScheme * call onedark#extend_highlight("LineNr", { "fg": { "gui": "#5C6370" } })
""" autocmd ColorScheme * call onedark#extend_highlight("CursorLineNr", { "fg": { "gui": "#56B6C2" } })
augroup END

colorscheme dracula
