" =====================================================================
"                               Vim config
" =====================================================================

set nocompatible
scriptencoding utf-8

" ---------------------------------------------------------------------
"                                  Base
" ---------------------------------------------------------------------
set encoding=utf-8
set fileencodings=utf-8,latin1
set hidden
set confirm
set updatetime=200
set timeoutlen=400
set ttimeoutlen=10

"                           System integration
set clipboard=unnamedplus
set mouse=a

"                               UI behavior
set cmdheight=1
set shortmess+=c
set noshowmode
set signcolumn=no

" ---------------------------------------------------------------------
"                                Security
" ---------------------------------------------------------------------
set nomodeline
set modelines=0

" ---------------------------------------------------------------------
"                               Performance
" ---------------------------------------------------------------------
set lazyredraw
set synmaxcol=220
set completeopt=menuone,noinsert,noselect

" ---------------------------------------------------------------------
"                          Backup swap undo
" ---------------------------------------------------------------------
set backup writebackup swapfile undofile

let s:tmp = expand('~/.vim/tmp')
for s:d in ['backup', 'swap', 'undo']
  if !isdirectory(s:tmp . '/' . s:d)
    call mkdir(s:tmp . '/' . s:d, 'p')
  endif
endfor
execute 'set backupdir=' . s:tmp . '/backup//,.'
execute 'set directory=' . s:tmp . '/swap//,.'
execute 'set undodir='   . s:tmp . '/undo//,.'

" ---------------------------------------------------------------------
"                               UI editing
" ---------------------------------------------------------------------
syntax enable
filetype plugin indent on

if has('termguicolors')
  set termguicolors
endif
set background=dark

set number relativenumber cursorline
set wrap linebreak
set scrolloff=6 sidescrolloff=6
set showmatch incsearch hlsearch ignorecase smartcase
set splitbelow splitright

set tabstop=4 shiftwidth=4 softtabstop=4
set expandtab smartindent autoindent shiftround

set wildmenu
set wildmode=longest:full,full
set backspace=indent,eol,start

set pastetoggle=<F2>
set autoread

"                           Less builtin clutter
let g:loaded_matchit    = 1
let g:loaded_matchparen = 1

" ---------------------------------------------------------------------
"                                 Leader
" ---------------------------------------------------------------------
let mapleader      = " "
let maplocalleader = "\\"

" ---------------------------------------------------------------------
"                               Core mappings
" ---------------------------------------------------------------------

"                              Save / quit
nnoremap <silent> <leader>w :w<CR>
nnoremap <silent> <leader>q :q<CR>
nnoremap <silent> <leader>Q :qa!<CR>

"                              Ctrl-Q quit
nnoremap <silent> <C-q> :q<CR>
inoremap <silent> <C-q> <Esc>:q<CR>
vnoremap <silent> <C-q> <Esc>:q<CR>

"                             Clear search
nnoremap <silent> <leader>h :nohlsearch<CR>

"                             Escape insert
inoremap jk <Esc>

"                             Wrapped move
nnoremap j gj
nnoremap k gk

"                             Visual indent (keep selection)
vnoremap < <gv
vnoremap > >gv

"                             Visual search
vnoremap // y/\V<C-R>"<CR>

"                            Buffer control
nnoremap <silent> <leader>bn :bnext<CR>
nnoremap <silent> <leader>bp :bprevious<CR>
nnoremap <silent> <leader>bd :bdelete<CR>
nnoremap <silent> <leader>bl :ls<CR>

"                             Split control
nnoremap <silent> <leader>sv :vsplit<CR>
nnoremap <silent> <leader>sh :split<CR>
nnoremap <silent> <leader>sc :close<CR>

"                              Split move
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"                              Move lines
nnoremap <M-j> :m .+1<CR>==
nnoremap <M-k> :m .-2<CR>==
vnoremap <M-j> :m '>+1<CR>gv=gv
vnoremap <M-k> :m '<-2<CR>gv=gv

"                            Clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>p "+p
vnoremap <leader>p "+p

"                               QOL scroll
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

"                        Interactive substitution
nnoremap <leader>s :call <SID>InteractiveSearchReplace()<CR>

function! s:InteractiveSearchReplace() abort
  let l:search  = input('Search: ')
  let l:replace = input('Replace with: ')
  execute '%s/' . escape(l:search, '/\') . '/' . escape(l:replace, '/\') . '/gc'
endfunction

"                     Replace word under cursor
nnoremap <leader>r :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>

"                              Vimrc edit / reload
nnoremap <silent> <leader>vc :vsplit $MYVIMRC<CR>
nnoremap <silent> <leader>vr :source $MYVIMRC<CR>

"                              PDF viewer
nnoremap <silent> <leader>pdf :!okular %:r.pdf &<CR>

" ---------------------------------------------------------------------
"                               Plugins
" ---------------------------------------------------------------------
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !mkdir -p ~/.vim/autoload
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  augroup PlugBootstrap
    autocmd!
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  augroup END
endif

call plug#begin('~/.vim/plugged')

"                             Sensible defaults
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

"                                 Git tools
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

"                               Status line
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"                              Tree / finder
Plug 'preservim/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

"                                UX helpers
Plug 'michaltarasik/beacon.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'preservim/nerdcommenter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }

"                                Lint / fix
Plug 'dense-analysis/ale'

"                             Completion / LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

"                                Jupyter
Plug 'jpalardy/vim-slime'

"                               AI / theme
Plug 'madox2/vim-ai'
Plug 'fxn/vim-monochrome'

call plug#end()

" ---------------------------------------------------------------------
"                            Plugin settings
" ---------------------------------------------------------------------

"                             Airline
let g:airline_powerline_fonts        = 1
let g:airline_theme                  = 'dark'
let g:airline#extensions#ale#enabled = 0
let g:airline#extensions#coc#enabled = 1

"                            GitGutter
let g:gitgutter_enabled = 0

"                             NERDTree
let g:NERDTreeShowHidden          = 0
let g:NERDTreeMinimalUI           = 1
let g:NERDTreeWinSize             = 25
let g:NERDTreeQuitOnOpen          = 1
let g:NERDTreeDirArrowExpandable  = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

nnoremap <silent> <leader>e :NERDTreeToggle<CR>
nnoremap <silent> <leader>f :NERDTreeFind<CR>

augroup NerdTreeCloseIfOnly
  autocmd!
  autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && get(b:NERDTree, 'isTabTree', 0) | quit | endif
augroup END

"                               FZF
let g:fzf_layout         = { 'down': '~40%' }
let g:fzf_devicons       = 1
let g:fzf_preview_window = ['right:50%', 'ctrl-/']

if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
endif

nnoremap <silent> <leader>ff :Files<CR>
nnoremap <silent> <leader>fg :Rg<CR>
nnoremap <silent> <leader>b  :Buffers<CR>
nnoremap <silent> <leader>H  :History<CR>

"                           UndoTree
nnoremap <silent> <leader>u :UndotreeToggle<CR>

"                           vim-slime (Jupyter / tmux)
let g:slime_target              = "tmux"
let g:slime_default_config      = {"socket_name": "default", "target_pane": "{right-of}"}
let g:slime_dont_ask_default    = 1

"                              ALE
let g:ale_disable_lsp     = 1
let g:ale_linters_explicit = 1
let g:ale_fix_on_save     = 1

let g:ale_linters = {
\  'python': ['flake8'],
\  'tex':    ['chktex'],
\  'sh':     ['shellcheck'],
\}

let g:ale_fixers = {
\  'python': ['black'],
\  'sh':     ['shfmt'],
\}

" ---------------------------------------------------------------------
"                           CoC / LSP mappings
" ---------------------------------------------------------------------
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gr <Plug>(coc-references)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gy <Plug>(coc-type-definition)

nnoremap <silent> K          :call CocActionAsync('doHover')<CR>
nnoremap <silent> <leader>rn <Plug>(coc-rename)
nnoremap <silent> <leader>ca <Plug>(coc-codeaction)
nnoremap <silent> [d         <Plug>(coc-diagnostic-prev)
nnoremap <silent> ]d         <Plug>(coc-diagnostic-next)
nnoremap <silent> <leader>d  :call CocActionAsync('diagnosticInfo')<CR>

"                        CoC completion behavior
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr>         <S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <CR>    pumvisible() ? coc#_select_confirm() : "\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

" ---------------------------------------------------------------------
"                           Plug shortcuts
" ---------------------------------------------------------------------
nnoremap <silent> <leader>l  :PlugStatus<CR>
nnoremap <silent> <leader>a  :PlugInstall<CR>
nnoremap <silent> <leader>c  :PlugClean<CR>
nnoremap <silent> <leader>pu :PlugUpdate<CR>

" ---------------------------------------------------------------------
"                                  Theme
" ---------------------------------------------------------------------
colorscheme monochrome

" ---------------------------------------------------------------------
"                              Shell terminal
" ---------------------------------------------------------------------

"                            Terminal escape
tnoremap <Esc> <C-\><C-n>

"                              Shell detect
if exists('$SHELL') && executable($SHELL)
  let &shell = $SHELL
else
  let &shell = '/bin/sh'
endif

" ---------------------------------------------------------------------
"                            ShellHere terminal  (<LocalLeader>ll)
" ---------------------------------------------------------------------
let g:shellhere_bufnr = -1

function! s:DirOfCurrentFile() abort
  let l:file = expand('%:p')
  return empty(l:file) ? getcwd() : fnamemodify(l:file, ':h')
endfunction

function! ShellHereOpen() abort
  let l:dir = s:DirOfCurrentFile()

  if g:shellhere_bufnr > 0 && !bufexists(g:shellhere_bufnr)
    let g:shellhere_bufnr = -1
  endif

  belowright split

  if g:shellhere_bufnr > 0
    execute 'buffer ' . g:shellhere_bufnr
    if &buftype ==# 'terminal'
      call term_sendkeys(g:shellhere_bufnr, 'cd ' . shellescape(l:dir) . "\n")
      startinsert
      return
    endif
  endif

  execute 'lcd ' . fnameescape(l:dir)
  execute 'terminal ++curwin'
  let g:shellhere_bufnr = bufnr('%')

  setlocal noswapfile
  silent! setlocal modifiable
  silent! file ShellHere
  silent! setlocal nomodifiable

  startinsert
endfunction

nnoremap <silent> <LocalLeader>ll :call ShellHereOpen()<CR>
tnoremap <silent> <C-d>           <C-\><C-n>:bdelete!<CR>

" ---------------------------------------------------------------------
"                           Filetype settings
" ---------------------------------------------------------------------
augroup MyFiletypes
  autocmd!
  " python/rust use global default (ts=4); only override what differs
  autocmd FileType tex      setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab wrap linebreak spell
  autocmd FileType markdown setlocal wrap linebreak spell
  autocmd FileType gitcommit setlocal spell textwidth=72
augroup END

" ---------------------------------------------------------------------
"                              Final touches
" ---------------------------------------------------------------------
augroup TrimWhitespace
  autocmd!
  autocmd BufWritePre *.py,*.jl,*.rs,*.tex,*.md,*.sh %s/\s\+$//e
augroup END

augroup RestoreCursor
  autocmd!
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   execute "normal! g`\"" |
        \ endif
augroup END
