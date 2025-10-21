if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl  -fLo ~/.vim/autoload/plug.vim --create-dirs
	\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
  """ Themes
  Plug 'joshdick/onedark.vim'
  Plug 'junegunn/seoul256.vim'
  Plug 'ronny/birds-of-paradise.vim'

  """ UI 
  Plug 'junegunn/goyo.vim'
  Plug 'vim-airline/vim-airline'
  Plug 'sheerun/vim-polyglot'
  
  """ Syntax 
  Plug 'dense-analysis/ale'
  Plug 'pangloss/vim-javascript'
  Plug 'wuelnerdotexe/vim-astro'
  Plug 'leafgarland/typescript-vim'
  Plug 'maxmellon/vim-jsx-pretty'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  Plug 'junegunn/fzf', { 'do': { -> fzf#install() }}
  Plug 'junegunn/fzf.vim'
  Plug 'preservim/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'airblade/vim-gitgutter'
  Plug 'mg979/vim-visual-multi'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-commentary'

  Plug 'dhruvasagar/vim-table-mode'

call plug#end()

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
set re=2
" set regexpengine=1
set synmaxcol=200
syntax sync minlines=256
syntax sync maxlines=256
set ttyfast
set lazyredraw " Do not update screen during macro and script execution
set updatetime=300

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
set cino+=(0 " When in unclosed parens, ie args, have them line up
set showmatch
set title
set list
set listchars=tab:>-
set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

set number relativenumber
set numberwidth=3
set foldcolumn=2

set cursorline
set cursorlineopt=both
set nocursorcolumn

set nobackup
set nowritebackup


    
"=================== Undo Backup =========================" 
set undodir=~/.vim/backup
set undofile
set undoreload=10000

"=================== Miscellaneous ===================" 
set autochdir
set undolevels=1000	
set backspace=indent,eol,start
set shiftwidth=2 tabstop=2 expandtab
set autoread " Auto reload files that are changed outside of vim
set vb t_vb= " Removes annyoing beeps when bad command
set noswapfile " Disable creating .swp files
set laststatus=2

" Refresh Vim buffers on git changes
set autoread
autocmd FocusGained * checktime

"==================  Mapping Commands ======" 
" Press the space bar to type the : character in command mode.
nnoremap , :

" Yank from cursor to the end of line.
nnoremap Y y$

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
nnoremap <S-j> :m+<CR>
nnoremap <S-k> :m-2<CR>

" Yank to system clipboard
set clipboard=unnamed

"------------------  Moonlander Meh ------" 
map <A><S><Cr>b :b#

"=================== Custom Commands ===================" 
:command! -nargs=1 Silent execute ':silent !'.<q-args> | execute ':redraw!'

"==================  Leader mapping  =====" 
nnoremap <space> <nop>
let mapleader = " "

function! ToggleLineNumber()
  set norelativenumber!
  set nonumber!
endfunction

nnoremap <leader>v <c-w>v
nnoremap <leader>s <c-w>s

nnoremap <leader>h <c-w>h
nnoremap <leader>j <c-w>j
nnoremap <leader>k <c-w>k
nnoremap <leader>l <c-w>l

nnoremap <leader>= <c-w>=
nnoremap <leader>/ :nohlsearch<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :wq!<CR>
nnoremap <leader>b :b#<CR>
nnoremap <leader>T :terminal<CR>

nnoremap <leader>fr :%s///g
nnoremap <leader>n :call ToggleLineNumber()<CR>
nnoremap <leader>c :call ToggleLineColumn()<CR>
nnoremap <leader>as :Silent ,auto-save<CR>

nnoremap <leader>ga :Git add .<CR> 
nnoremap <leader>gs :Git status<CR> 
nnoremap <leader>gc :Git commit<CR> 
nnoremap <leader>gC :Git commit -m 
" nnoremap <leader>gd :Git diff .<CR> 
" nnoremap <leader>gD :Git diff<CR> 

nnoremap <leader>1 :Goyo<CR> 
nnoremap <leader>2 :TableModeToggle<CR> 

nnoremap <leader>[ :colorscheme onedark<CR> 
nnoremap <leader>] :colorscheme seoul256<CR> 

"============================================
"============= PLUGINS ======================
"============================================

"-------------------------------------------- 
"------------- COC --------------------- 
"-------------------------------------------- 
let g:coc_global_extensions = ['coc-tsserver']
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
autocmd CursorHold * silent call CocActionAsync('highlight')
"-------------------------------------------- 
"------------- Ale --------------------- 
"-------------------------------------------- 
let g:ale_linters = {
\ 'javascript': ['eslint'],
\ 'javascriptreact': ['eslint'],
\ 'typescript': ['eslint'],
\ 'typescriptreact': ['eslint'],
\}

let g:ale_fixers = {
\ 'javascript': ['prettier'],
\ 'javascriptreact': ['prettier'],
\ 'typescript': ['prettier'],
\ 'typescriptreact': ['prettier'],
\ 'css': ['prettier'],
\ 'json': ['prettier'],
\}
" \ 'php': ['pint'],

let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_save = 1
let g:ale_sign_column_always = 1
" let g:ale_php_pint_executable = './vendor/bin/pint'
" let g:ale_php_pint_use_global = 0
" let g:ale_php_pint_options = '--config=pint.json'
" let g:prettier#autoformat_config_files = ['.prettierrc.json']
" let g:ng at every change you may want to disable quickfix
" let g:prettier#quickfix_enabled = 0
" autocmd TextChanged,InsertLeave *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.svelte,*.yaml,*.html 
"
"-------------------------------------------- 
"------------- Astro --------------------- 
"-------------------------------------------- 
let g:astro_typescript = 'enable'

"-------------------------------------------- 
"------------- Goyo ------------------------- 
"-------------------------------------------- 
"let g:goyo_height='85%'
"let g:goyo_width='85%'

function! s:goyo_enter()
  let b:quitting = 0
  let b:quitting_bang = 0
  autocmd QuitPre <buffer> let b:quitting = 1
  cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!

  set number
  set relativenumber
  set nocursorline

  colorscheme seoul256

  hi FoldColumn guibg=bg guifg=fg
  hi LineNr guibg=bg guifg=#262626
  hi CursorLineNr guibg=bg guifg=#5f875f
endfunction

function! s:goyo_leave()
  " Quit Vim if this is the only remaining buffer
  if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    if b:quitting_bang
      qa!
    else
      qa
    endif
  endif

  set number
  set relativenumber
  set cursorline

  colorscheme onedark
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

"------------------- fzf -------------------" 
map ; :GFiles<CR> 

"------------------- Rust ------------------" 
let g:rustfmt_autosave = 1

"------------------- Ledger -------------------" 
au BufNewFile,BufRead *.ldg,*.ledger setf ledger | comp ledger 
let g:ledger_fillstring = '    -'
let g:ledger_maxwidth = 120
let g:ledger_fold_blanks = 1
let g:ledger_align_at = 80
let g:ledger_autofmt_bufwritepre = 1
"au! BufWrite *.ledger write | :%LedgerAlign 
"autocmd Filetype ledger setlocal nowrap
" ledger print removes comments outside of transactions
function LedgerSort()
  :%! ledger -f - print --sort 'date, amount' 
  :%LedgerAlign
endfunction
command LedgerSort call LedgerSort()

"------------------- NERDTree -------------------" 
nnoremap <leader>t :NERDTreeToggle<CR>
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeShowHidden = 1
let g:NERDTreeGitStatusConcealBrackets = 1
let g:NERDTreeWinSize = 30
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"------------------- netrw -------------------" 
let g:netrw_banner = 0
let g:netew_liststyle =3
let g:netrw_browse_split = 2
let g:netrw_altv = 1
let g:netrw_winsize = 25

"=================== Table Formatting ===================" 
au! BufNewFile,BufRead *.csv.md set filetype=CSV_Markdown
autocmd Filetype CSV_Markdown setlocal nowrap
au! BufWrite *.csv.md write | :TableModeRealign
au BufNewFile,BufRead *.csv.md syntax match Structure "\v\/|"
au BufNewFile,BufRead *.csv.md syntax match Structure "\v\=.*$"
au BufNewFile,BufRead *.csv.md syntax match Structure "\v\-.*$"

au BufNewFile,BufRead *.csv.md syntax match Error "\v\+debt"
au BufNewFile,BufRead *.csv.md syntax match Function "\v\+home"
au BufNewFile,BufRead *.csv.md syntax match Constant "\v\+tech"
au BufNewFile,BufRead *.csv.md syntax match Constant "\v\+office"
au BufNewFile,BufRead *.csv.md syntax match Boolean "\v\+upgrade"
au BufNewFile,BufRead *.csv.md syntax match Statement "\v\+clothing"
au BufNewFile,BufRead *.csv.md syntax match String "\v\+health"
au BufNewFile,BufRead *.csv.md syntax match Structure "\v\+cooking"
au BufNewFile,BufRead *.csv.md syntax match Structure "\v\+gift"
au BufNewFile,BufRead *.csv.md syntax match Structure "\v\+travel"
au BufNewFile,BufRead *.csv.md syntax match Structure "\v\+camping"

" dark red
hi tsxTagName guifg=#E06C75
hi tsxComponentName guifg=#E06C75
hi tsxCloseComponentName guifg=#E06C75

" orange
hi tsxCloseString guifg=#F99575
hi tsxCloseTag guifg=#F99575
hi tsxCloseTagName guifg=#F99575
hi tsxAttributeBraces guifg=#F99575
hi tsxEqual guifg=#F99575

" yellow
hi tsxAttrib guifg=#F8BD7F cterm=italic

"=================== THEMES ===================" 
syntax on
set termguicolors
set background=dark

"=================== SEOUL256 ===================" 
let g:seoul256_background=236
let g:seoul256_light_background=256

"=================== ONEDARK ===================" 

let g:onedark_hide_endofbuffer=1
let g:airline_theme="onedark"

augroup colorextend
  autocmd!
  autocmd ColorScheme * call onedark#extend_highlight("CursorLineNr", { "fg": { "gui": "#13ffff" } })
  ":"autocmd ColorScheme * call onedark#extend_highlight("CursorLineNr", { "fg": { "gui": "#56B6C2" } })
augroup END

colorscheme onedark
