" ============================================================
"                      FRA VIM CONFIG
" ============================================================

" =======================  BASE  ============================
set nocompatible
set encoding=utf-8
set fileencoding=utf-8
set hidden
set confirm
set updatetime=200
set timeoutlen=400
set ttimeoutlen=10
set clipboard=unnamedplus
set mouse=a
set signcolumn=yes
set cmdheight=1
set shortmess+=c
set noshowmode

" ===================  BACKUP / SWAP  ======================
set backup
set writebackup
set swapfile
set undofile

set backupdir=~/.vim/tmp/backup//,.
set directory=~/.vim/tmp/swap//,.
set undodir=~/.vim/tmp/undo//,.

for dir in ['backup','swap','undo']
  if !isdirectory(expand('~/.vim/tmp/'.dir))
    call mkdir(expand('~/.vim/tmp/'.dir), 'p')
  endif
endfor

" =======================  UI  ==============================
syntax enable
filetype plugin indent on

set termguicolors
set background=dark

set number
set relativenumber
set cursorline
set wrap
set linebreak
set scrolloff=6
set sidescrolloff=6

set showmatch
set incsearch
set hlsearch
set ignorecase
set smartcase

set tabstop=4
set shiftwidth=4
set expandtab
set smartindent

set splitbelow
set splitright

" =====================  LEADER  ============================
let mapleader=" "
let maplocalleader="\\"

" ==================  BASIC MAPPINGS  ======================
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :qa!<CR>
nnoremap <leader>/ :nohlsearch<CR>

nnoremap <leader>sv :vsplit<CR>
nnoremap <leader>sh :split<CR>

vnoremap < <gv
vnoremap > >gv

set pastetoggle=<F2>

" ============================================================
"                        PLUGINS
" ============================================================
call plug#begin('~/.vim/plugged')

" --------------------  CORE  -------------------------------
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'

" ------------------  ICONS (ALL-THE-ICONS STYLE) -----------
Plug 'ryanoasis/vim-devicons'

" ------------------  STATUSLINE  ---------------------------
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" ----------------  FILES / SEARCH  -------------------------
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" --------------------  UX  ---------------------------------
Plug 'michaltarasik/beacon.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'preservim/nerdcommenter'

" ----------------  LINT / FORMAT  --------------------------
Plug 'dense-analysis/ale'

" ----------------  COMPLETION / LSP  -----------------------
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" =======================  PYTHON  ==========================
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'tmhedberg/SimpylFold'

" =======================  JULIA  ===========================
Plug 'JuliaEditorSupport/julia-vim'
Plug 'kdheepak/JuliaFormatter.vim'

" =========================  R  =============================
Plug 'jalvesaq/Nvim-R'
Plug 'jpalardy/vim-slime'

" =======================  LATEX  ===========================
Plug 'lervag/vimtex'

call plug#end()

" ============================================================
"                         ICONS
" ============================================================
let g:webdevicons_enable = 1
let g:webdevicons_enable_airline_tabline = 1
let g:webdevicons_enable_airline_statusline = 1
let g:webdevicons_enable_nerdtree = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1

" ============================================================
"                        AIRLINE
" ============================================================
let g:airline_powerline_fonts = 1
let g:airline_theme = 'dark'

" ============================================================
"                        NERDTREE
" ============================================================
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>

" Close Vim if NERDTree is the last window
autocmd BufEnter * if winnr('$') == 1
      \ && exists('b:NERDTree')
      \ && b:NERDTree.isTabTree()
      \ | quit | endif

" ============================================================
"                           FZF
" ============================================================
let g:fzf_layout = { 'down': '~40%' }
let g:fzf_devicons = 1

nnoremap <leader>p  :Files<CR>
nnoremap <leader>rg :Rg<CR>
nnoremap <leader>b  :Buffers<CR>

" ============================================================
"                           ALE
" ============================================================
let g:ale_completion_enabled = 0
let g:ale_fix_on_save = 1

" Explicit fixers so ALE doesn't pick random tools
let g:ale_fixers = {
\ 'python': ['black', 'isort'],
\ 'julia':  ['juliaformatter'],
\ 'tex':    ['latexindent'],
\}

" ============================================================
"                             C O C
" ============================================================
let g:coc_global_extensions = [
\ 'coc-snippets',
\ 'coc-pyright',
\ 'coc-julia',
\ 'coc-json',
\ 'coc-yaml'
\]

set completeopt=menuone,noinsert,noselect

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

" TAB navigates completion menu (more standard)
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap',['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

inoremap <silent><expr> <S-TAB>
      \ coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Enter confirms if menu is visible
inoremap <silent><expr> <CR>
      \ coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" ============================================================
"                        SLIME
" ============================================================
let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "{right-of}"}
let g:slime_bracketed_paste = 1

xmap <leader>ss <Plug>SlimeRegionSend
nmap <leader>sl <Plug>SlimeLineSend

" ============================================================
"                        JULIA
" ============================================================
autocmd FileType julia nnoremap <buffer> <leader>jf :JuliaFormatterFormat<CR>

" ============================================================
"                        PYTHON
" ============================================================
autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab

" ============================================================
"                        LATEX
" ============================================================
" Use okular integration directly (better sync in many setups)
let g:vimtex_view_method = 'okular'
let g:vimtex_view_general_viewer = 'okular'
