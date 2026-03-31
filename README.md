# Vim-config

A comprehensive, modern Vim configuration optimized for academic work, computational research, and software development. Built with vim-plug for plugin management and CoC for IDE-like features.

## Table of Contents

- [Overview](#overview)
- [Requirements](#requirements)
- [Installation](#installation)
  - [Dependencies on Arch Linux](#dependencies-on-arch-linux)
  - [Configuration Setup](#configuration-setup)
- [Configuration Sections](#configuration-sections)
- [Features](#features)
- [Keybindings](#keybindings)
- [Plugin Guide](#plugin-guide)
- [Troubleshooting](#troubleshooting)

## Overview

This is a production-ready Vim configuration written in VimScript. It emphasizes:

- **Minimal dependencies**: Only essential plugins, no bloat
- **Fast startup**: Lazy-loading plugins for instant responsiveness
- **IDE capabilities**: Full LSP support via Conqueror of Completion (CoC)
- **Git integration**: Fugitive and GitGutter for version control workflows
- **Keyboard-centric**: Extensive customizable keybindings (Space as leader key)
- **Multi-language**: Support for Python, Rust, Julia, LaTeX, Shell, and more
- **Interactive tools**: FZF for fuzzy finding, Undotree for history, Jupyter integration via vim-slime

## Requirements

### System Requirements

- **OS**: Linux (tested on Arch Linux)
- **Vim**: Version 8.0+ with `+clipboard`, `+terminal`, and `+python3` support
- **Terminal**: Any terminal supporting 24-bit color and UTF-8
- **Shell**: Bash, Zsh, or Fish

### Arch Linux Dependencies

Install Vim and core tools:

```bash
# Core editor
sudo pacman -S vim gvim

# Essential tools
sudo pacman -S git ripgrep fd curl
```

### Optional System Dependencies

Based on features and language support:

```bash
# Language servers & linters
sudo pacman -S python-lsp-server python-pylsp-mypy flake8 black
sudo pacman -S shellcheck shfmt

# LaTeX
sudo pacman -S texlive-latex texlive-fonts texlive-xetex
sudo pacman -S chktex  # LaTeX linter

# Programming language runtimes
sudo pacman -S python julia rust go nodejs

# Fuzzy finder & utilities
sudo pacman -S fzf ripgrep fd

# Tmux (for vim-slime/vim-tmux-navigator)
sudo pacman -S tmux

# PDF viewer (optional)
sudo pacman -S okular

# Spell checking
sudo pacman -S aspell aspell-en
```

---

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/vim-config ~/.vim
cd ~/.vim
```

### 2. Create Required Directories

```bash
mkdir -p ~/.vim/{autoload,plugged,tmp/{backup,swap,undo}}
```

The configuration automatically creates these, but pre-creating them is cleaner.

### 3. Install vim-plug (Plugin Manager)

The configuration includes a bootstrap script that auto-installs vim-plug on first launch:

```bash
# vim-plug will be installed automatically when you first run vim
vim
```

The bootstrap will:
1. Detect missing vim-plug
2. Download it from GitHub
3. Run `:PlugInstall` automatically
4. Reload the configuration

### 4. Install Plugins

If vim-plug wasn't auto-installed, install manually:

```vim
:PlugInstall
```

This downloads all plugins from the plugin list. First install typically takes 1-3 minutes.

### 5. Configure CoC Language Servers

CoC requires language servers for specific languages. Install via npm:

```bash
# Install npm (if not already installed)
sudo pacman -S npm

# Install language servers
npm install -g pyright          # Python
npm install -g vscode-langservers-extracted  # HTML/CSS/JSON
npm install -g bash-language-server         # Bash/Shell
npm install -g typescript      # TypeScript/JavaScript
```

Or configure CoC to use system language servers:

```bash
# In Vim:
:CocConfig
```

Then add your language servers to the configuration.

### 6. Verify Installation

Open Vim and run:

```vim
:checkhealth
:PlugStatus
:CocStatus
```

All should show "OK" status.

---

## Configuration Sections

### **Base Settings**

#### **Encoding & Compatibility**
```vim
set nocompatible
scriptencoding utf-8
set encoding=utf-8
set fileencodings=utf-8,latin1
```
- **nocompatible**: Enables Vim-specific features (required for plugins)
- **scriptencoding utf-8**: All config files are UTF-8 encoded
- **encoding/fileencodings**: Handles Unicode text correctly
- Essential for modern text editing and proper character display

#### **Buffer & File Handling**
```vim
set hidden          " Allow hidden unsaved buffers
set confirm         " Ask before discarding unsaved changes
set updatetime=200  " Faster updates (for gitgutter, CoC)
set timeoutlen=400  " Time to wait for key sequences
set ttimeoutlen=10  " Terminal key sequence timeout (low for responsiveness)
```

- **hidden**: Switch between buffers without saving (essential for workflows with many open files)
- **updatetime**: Controls how often Vim checks for changes and updates plugins like GitGutter
- **timeoutlen/ttimeoutlen**: Controls key sequence recognition (keybindings, escape sequences)

#### **System Integration**
```vim
set clipboard=unnamedplus  " Sync with system clipboard
set mouse=a                " Enable mouse support (selection, scrolling, clicking)
```

- **clipboard=unnamedplus**: `y` and `p` work with system clipboard (no need for `+y`, `+p`)
- **mouse=a**: Full mouse support (useful in GUI and terminal modes)

#### **UI Behavior**
```vim
set cmdheight=1      " Command line height (1 line, not 2)
set shortmess+=c     " Don't show completion messages
set noshowmode       " Don't show --INSERT-- in status bar (shown by airline)
set signcolumn=no    " Don't show sign column (less clutter)
```

- Minimizes visual noise while keeping essential info via status bar plugin

---

### **Security**

```vim
set nomodeline
set modelines=0
```

- Disables modelines (prevents executing arbitrary code from file comments)
- Recommended security practice

---

### **Performance Tuning**

```vim
set lazyredraw          " Don't redraw during macros
set synmaxcol=220       " Don't syntax highlight beyond column 220 (large files)
set completeopt=menuone,noinsert,noselect
```

- **lazyredraw**: Improves macro execution speed significantly
- **synmaxcol**: Syntax highlighting can be slow for very long lines; limit to 220 chars
- **completeopt**: Controls CoC completion menu behavior:
  - `menuone`: Show menu even with one match
  - `noinsert`: Don't auto-insert selected text
  - `noselect`: Don't auto-select first candidate

---

### **Backup, Swap, Undo**

```vim
set backup writebackup swapfile undofile

let s:tmp = expand('~/.vim/tmp')
for s:d in ['backup', 'swap', 'undo']
  if !isdirectory(s:tmp . '/' . s:d)
    call mkdir(s:tmp . '/' . s:d, 'p')
  endif
endfor
execute 'set backupdir=' . s:tmp . '/backup//,.'
execute 'set directory='   . s:tmp . '/swap//,.'
execute 'set undodir='     . s:tmp . '/undo//,.'
```

- **backup/writebackup**: Create backup files (safer editing)
- **swapfile**: Create `.swp` files for recovery after crashes
- **undofile**: Persistent undo across sessions (can undo after closing and reopening)
- All stored in `~/.vim/tmp/` subdirectories to keep working directory clean
- The loop creates directories if they don't exist

---

### **UI & Editing Behavior**

#### **Syntax & Appearance**
```vim
syntax enable
filetype plugin indent on

if has('termguicolors')
  set termguicolors
endif
set background=dark
```

- **syntax enable**: Turn on syntax highlighting
- **filetype plugin indent on**: Load language-specific plugins and indentation rules
- **termguicolors**: Enable 24-bit true color (modern terminals)
- **background=dark**: Optimize color scheme for dark backgrounds

#### **Visual Feedback**
```vim
set number relativenumber  " Show line numbers + relative numbers
set cursorline             " Highlight current line
set wrap linebreak         " Soft-wrap long lines at word boundaries
set scrolloff=6 sidescrolloff=6  " Keep 6 lines visible around cursor
```

- **relativenumber**: Show distance from current line (great for jump commands like `5j`)
- **cursorline**: Helps find cursor position
- **wrap linebreak**: Long lines wrap visually without breaking at mid-word
- **scrolloff**: Keeps context visible when navigating (prevents cursor jumping to edge)

#### **Search & Match**
```vim
set showmatch incsearch hlsearch  " Show matching brackets, highlight search incrementally
set ignorecase smartcase         " Smart case: lowercase→case-insensitive, uppercase→case-sensitive
```

- **showmatch**: Flashing bracket/paren matching helps verify structure
- **incsearch**: Find as you type
- **hlsearch**: Highlight all matches
- **smartcase**: Usually search is case-insensitive (faster), but becomes case-sensitive if you use uppercase

#### **Split & Window Behavior**
```vim
set splitbelow splitright  " New splits open below/right of current window
```

- More intuitive split placement (follows natural left-to-right, top-to-bottom reading)

#### **Indentation**
```vim
set tabstop=4 shiftwidth=4 softtabstop=4  " 4 spaces per indent
set expandtab              " Use spaces instead of tabs
set smartindent autoindent shiftround     " Auto-indent, round to shiftwidth
```

- **tabstop=4**: Each tab displays as 4 spaces
- **shiftwidth=4**: `>>` operator indents by 4 spaces
- **softtabstop=4**: Backspace deletes 4 spaces as one unit
- **expandtab**: Convert tabs to spaces (required for most projects)
- **smartindent/autoindent**: Automatically match indentation
- **shiftround**: Round indent to nearest multiple of shiftwidth (cleaner)

#### **Command Mode & Navigation**
```vim
set wildmenu              " Show command completions
set wildmode=longest:full,full  " Complete longest match, then cycle through all
set backspace=indent,eol,start  " Backspace works across lines
set pastetoggle=<F2>      " Toggle paste mode (preserves formatting when pasting)
set autoread              " Reload files when changed externally
```

- **wildmenu**: Enhanced command completion (like shell completion)
- **pastetoggle**: Useful for pasting large blocks from external sources

#### **Reduce Builtin Clutter**
```vim
let g:loaded_matchit    = 1  " Disable matchit plugin
let g:loaded_matchparen = 1  " Disable paren highlighting
```

- Disables built-in plugins that might conflict with modern alternatives

---

### **Leader Keys & Core Keybindings**

#### **Leader Configuration**
```vim
let mapleader      = " "   " Space as leader
let maplocalleader = "\\"  " Backslash for local leader (buffer-specific)
```

- Space leader is non-intrusive (unused in normal mode normally)
- All custom keybindings start with `<Space>`

#### **Save & Quit**
```vim
nnoremap <silent> <leader>w :w<CR>       " Space-w: Save
nnoremap <silent> <leader>q :q<CR>       " Space-q: Quit
nnoremap <silent> <leader>Q :qa!<CR>     " Space-Q: Quit all (force)
nnoremap <silent> <C-q> :q<CR>           " Ctrl-q: Quit (works in all modes)
```

#### **Search & Navigation**
```vim
nnoremap <silent> <leader>h :nohlsearch<CR>  " Space-h: Clear search highlight
inoremap jk <Esc>                             " jk: Escape from insert mode
nnoremap j gj                                 " j: Down (respect word wrap)
nnoremap k gk                                 " k: Up (respect word wrap)
```

#### **Visual Mode**
```vim
vnoremap < <gv  " < : Dedent + keep selection
vnoremap > >gv  " > : Indent + keep selection
vnoremap // y/\V<C-R>"<CR>  " // : Search for selected text
```

- Very useful for iterative indentation and searching for specific text

#### **Buffer Control**
```vim
nnoremap <silent> <leader>bn :bnext<CR>      " Space-b-n: Next buffer
nnoremap <silent> <leader>bp :bprevious<CR>  " Space-b-p: Previous buffer
nnoremap <silent> <leader>bd :bdelete<CR>    " Space-b-d: Delete buffer
nnoremap <silent> <leader>bl :ls<CR>         " Space-b-l: List buffers
```

#### **Window/Split Control**
```vim
nnoremap <silent> <leader>sv :vsplit<CR>  " Space-s-v: Vertical split
nnoremap <silent> <leader>sh :split<CR>   " Space-s-h: Horizontal split
nnoremap <silent> <leader>sc :close<CR>   " Space-s-c: Close split

nnoremap <C-h> <C-w>h  " Ctrl-h: Focus left
nnoremap <C-j> <C-w>j  " Ctrl-j: Focus down
nnoremap <C-k> <C-w>k  " Ctrl-k: Focus up
nnoremap <C-l> <C-w>l  " Ctrl-l: Focus right
```

#### **Line Movement**
```vim
nnoremap <M-j> :m .+1<CR>==     " Alt-j: Move line down
nnoremap <M-k> :m .-2<CR>==     " Alt-k: Move line up
vnoremap <M-j> :m '>+1<CR>gv=gv " Alt-j: Move selection down
vnoremap <M-k> :m '<-2<CR>gv=gv " Alt-k: Move selection up
```

#### **Clipboard Operations**
```vim
nnoremap <leader>y "+y  " Space-y: Copy to system clipboard
nnoremap <leader>p "+p  " Space-p: Paste from system clipboard
vnoremap <leader>y "+y
vnoremap <leader>p "+p
```

#### **Smart Scrolling**
```vim
nnoremap <C-d> <C-d>zz  " Ctrl-d: Page down + center cursor
nnoremap <C-u> <C-u>zz  " Ctrl-u: Page up + center cursor
nnoremap n nzzzv        " n: Next search + center + unfold
nnoremap N Nzzzv        " N: Previous search + center + unfold
```

- `zz` centers cursor on screen (great for readability)

#### **Search & Replace**
```vim
nnoremap <leader>s :call <SID>InteractiveSearchReplace()<CR>
function! s:InteractiveSearchReplace() abort
  let l:search  = input('Search: ')
  let l:replace = input('Replace with: ')
  execute '%s/' . escape(l:search, '/\') . '/' . escape(l:replace, '/\') . '/gc'
endfunction

nnoremap <leader>r :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
```

- **Space-s**: Interactive search/replace in entire file (prompts for search & replacement)
- **Space-r**: Replace word under cursor (preset with `%s/word//gc`, just type replacement)

#### **Config Editing**
```vim
nnoremap <silent> <leader>vc :vsplit $MYVIMRC<CR>  " Space-v-c: Open vimrc
nnoremap <silent> <leader>vr :source $MYVIMRC<CR>  " Space-v-r: Reload vimrc
```

#### **Utilities**
```vim
nnoremap <silent> <leader>pdf :!okular %:r.pdf &<CR>  " Space-pdf: View PDF
```

---

### **Plugin Management (vim-plug)**

#### **Bootstrap**
```vim
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !mkdir -p ~/.vim/autoload
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  augroup PlugBootstrap
    autocmd!
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  augroup END
endif
```

- Automatically downloads vim-plug on first Vim launch
- Runs `:PlugInstall` and reloads config automatically

#### **Plugin Installation Shortcuts**
```vim
nnoremap <silent> <leader>l  :PlugStatus<CR>   " Space-l: Plugin status
nnoremap <silent> <leader>a  :PlugInstall<CR>  " Space-a: Install plugins
nnoremap <silent> <leader>c  :PlugClean<CR>    " Space-c: Remove unused plugins
nnoremap <silent> <leader>pu :PlugUpdate<CR>   " Space-p-u: Update plugins
```

---

## Plugins

### **Core Plugins**

#### **vim-sensible** (tpope)
```vim
Plug 'tpope/vim-sensible'
```
- Sensible defaults that should be in Vim by default
- Includes better backspace behavior, auto-indentation, etc.

#### **vim-surround** (tpope)
```vim
Plug 'tpope/vim-surround'
```

Surround text with quotes, brackets, tags, etc.

**Usage**:
- `cs"'`: Change `"hello"` → `'hello'`
- `ds"`: Delete quotes: `"hello"` → `hello`
- `ys$"`: Surround to end of line with `"`: `hello world` → `"hello world"`
- `ysiw}`: Surround word with braces: `word` → `{word}`

#### **vim-repeat** (tpope)
```vim
Plug 'tpope/vim-repeat'
```

Allows `.` (repeat) to work with plugin commands like vim-surround.

### **Git Integration**

#### **vim-fugitive** (tpope)
```vim
Plug 'tpope/vim-fugitive'
```

Full Git integration in Vim.

**Commands**:
- `:Git` or `:G`: Run git commands in Vim
- `:Git status`: View git status
- `:Git commit`: Make commits within Vim
- `:Git push`: Push changes
- `:Git diff`: Show diffs
- `:GBrowse`: Open current file on GitHub (requires Fugitive config)

#### **vim-gitgutter** (airblade)
```vim
Plug 'airblade/vim-gitgutter'
```

Shows git diff signs in the gutter (left margin).

**Disabled by default**: `let g:gitgutter_enabled = 0`

Toggle with: `:GitGutterToggle`

**Shows**:
- `+` for added lines
- `-` for deleted lines
- `~` for modified lines

### **Status Line & Icons**

#### **vim-airline** (vim-airline)
```vim
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
```

Modern status line showing mode, file name, git branch, line/column, etc.

**Configuration**:
```vim
let g:airline_powerline_fonts = 1     " Use Powerline glyphs
let g:airline#extensions#coc#enabled = 1  " Show CoC status
```

#### **vim-devicons** (ryanoasis)
```vim
Plug 'ryanoasis/vim-devicons'
```

File type icons in NERDTree and other plugins.

**Requirement**: Install a Nerd Font (e.g., `JetBrains Mono Nerd Font`)

```bash
sudo pacman -S nerd-fonts  # or specific nerd font package
# Then set your terminal/editor to use a Nerd Font
```

### **File Navigation**

#### **NERDTree** (preservim)
```vim
Plug 'preservim/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
```

File tree sidebar.

**Keybindings**:
- `<leader>e`: Toggle NERDTree
- `<leader>f`: Find current file in tree
- `o`: Open file
- `i`: Open in split
- `s`: Open in vertical split
- `t`: Open in new tab
- `m`: File menu (move, copy, delete)
- `I`: Toggle hidden files
- `?`: Show help

**Configuration**:
```vim
let g:NERDTreeShowHidden = 0           " Don't show hidden files by default
let g:NERDTreeMinimalUI = 1            " Minimal UI
let g:NERDTreeWinSize = 25             " Sidebar width: 25 chars
let g:NERDTreeQuitOnOpen = 1           " Auto-close after opening file
```

#### **FZF** (junegunn)
```vim
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
```

Fuzzy finder for files, buffers, and search results.

**Keybindings**:
- `<leader>ff`: Find files
- `<leader>fg`: Ripgrep search
- `<leader>b`: Search buffers
- `<leader>H`: Search history

**Configuration**:
```vim
let g:fzf_layout = { 'down': '~40%' }  " Show fzf in bottom 40% of screen
let g:fzf_preview_window = ['right:50%', 'ctrl-/']  " Preview on right
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
```

**Usage**: Type to filter, `Enter` to select, `Ctrl-/` to toggle preview.

---

### **Code Editing & Completion**

#### **CoC (Conqueror of Completion)**
```vim
Plug 'neoclide/coc.nvim', {'branch': 'release'}
```

Full IDE-like completion and LSP support.

**Features**:
- Code completion (Tab/Shift-Tab to navigate)
- Go to definition (gd)
- Find references (gr)
- Rename (Space-rn)
- Code actions (Space-ca)
- Diagnostics navigation ([d, ]d)

**Keybindings** (see CoC section):
- `gd`: Go to definition
- `gr`: Find references
- `gi`: Go to implementation
- `gy`: Go to type definition
- `K`: Show hover documentation
- `<leader>rn`: Rename symbol
- `<leader>ca`: Code actions
- `[d` / `]d`: Previous/next diagnostic
- `<leader>d`: Show diagnostics

**Configuration**: Edit with `:CocConfig` to add language servers.

#### **UltiSnips** (SirVer)
```vim
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
```

Snippet engine with a library of snippets.

**Usage**:
- Type snippet trigger (e.g., `for` in Python) and press `Tab`
- Jump between placeholders with `Tab`
- Use `${1:default}` syntax in custom snippets

**Example**:
```python
for<Tab>  # Expands to: for i in range(10):
```

#### **auto-pairs** (jiangmiao)
```vim
Plug 'jiangmiao/auto-pairs'
```

Auto-complete matching brackets, quotes, etc.

- Type `(` → auto-inserts `)`
- Type opening quote → auto-inserts closing quote
- `Alt-p`: Toggle auto-pairs

### **Editing Utilities**

#### **NERD Commenter** (preservim)
```vim
Plug 'preservim/nerdcommenter'
```

Comment/uncomment code.

**Keybindings** (default prefix: `<leader>c`):
- `<leader>c<space>`: Toggle comment
- `<leader>cc`: Comment line
- `<leader>cu`: Uncomment line
- Works in visual mode for multiple lines

#### **Beacon** (michaltarasik)
```vim
Plug 'michaltarasik/beacon.vim'
```

Flash cursor position when jumping to new location.

- Helpful for tracking cursor after large jumps (`Ctrl-u`, `Ctrl-d`, `gg`, `G`)

#### **vim-tmux-navigator** (christoomey)
```vim
Plug 'christoomey/vim-tmux-navigator'
```

Seamless navigation between Vim splits and Tmux panes with `Ctrl-hjkl`.

**Requires Tmux configuration** (see docs).

#### **undotree** (mbbill)
```vim
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
```

Visualize undo history as a tree.

**Keybinding**:
- `<leader>u`: Toggle undo tree

**Usage**: Navigate tree to restore to any previous state.

### **Linting & Fixing**

#### **ALE** (dense-analysis)
```vim
Plug 'dense-analysis/ale'
```

Async linting and fixing.

**Configuration**:
```vim
let g:ale_disable_lsp = 1         " Don't use LSP (CoC handles it)
let g:ale_linters_explicit = 1    " Only use configured linters
let g:ale_fix_on_save = 1         " Auto-fix on save

let g:ale_linters = {
\  'python': ['flake8'],
\  'tex':    ['chktex'],
\  'sh':     ['shellcheck'],
\}

let g:ale_fixers = {
\  'python': ['black'],
\  'sh':     ['shfmt'],
\}
```

**Shows**:
- Errors/warnings as red/yellow underlines
- Error messages in status line
- Quick fix list with `quickfix` commands

**Installation** (Arch Linux):
```bash
sudo pacman -S flake8 black shellcheck shfmt
```

### **Jupyter & Interactive Computing**

#### **vim-slime** (jpalardy)
```vim
Plug 'jpalardy/vim-slime'
```

Send code to Jupyter/IPython/Tmux for interactive evaluation.

**Configuration**:
```vim
let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "{right-of}"}
let g:slime_dont_ask_default = 1
```

**Usage**:
- `:SlimeSend1 <motion>`: Send motion to Tmux/Jupyter
- `:SlimeConfig`: Configure target pane
- Useful for data exploration and interactive development

### **AI Integration**

#### **vim-ai** (madox2)
```vim
Plug 'madox2/vim-ai'
```

AI-powered completion and code generation (integrates with OpenAI/local models).

- Get AI suggestions for code
- Ask questions about code
- Requires API key configuration

### **Theme**

#### **vim-monochrome** (fxn)
```vim
Plug 'fxn/vim-monochrome'
colorscheme monochrome
```

Clean, minimalist monochrome color scheme.

**Alternative themes**:
- `dracula`: Dark with vibrant colors
- `gruvbox`: Warm retro groove colors
- `nord`: Arctic, north-bluish theme
- `onedark`: Dark with syntax colors

---

## CoC LSP Mappings

```vim
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gr <Plug>(coc-references)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> K :call CocActionAsync('doHover')<CR>
nnoremap <silent> <leader>rn <Plug>(coc-rename)
nnoremap <silent> <leader>ca <Plug>(coc-codeaction)
nnoremap <silent> [d <Plug>(coc-diagnostic-prev)
nnoremap <silent> ]d <Plug>(coc-diagnostic-next)
nnoremap <silent> <leader>d :call CocActionAsync('diagnosticInfo')<CR>
```

### **IDE Keybindings**

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Find references |
| `gi` | Go to implementation |
| `gy` | Go to type definition |
| `K` | Show hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code actions (fix, refactor) |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<leader>d` | Show all diagnostics |

### **Completion Behavior**

```vim
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<CR>"
```

- `Tab`: Next completion, or refresh if no menu
- `Shift-Tab`: Previous completion
- `Enter`: Select completion

---

## Terminal Integration

### **Built-in Terminal**
```vim
tnoremap <Esc> <C-\><C-n>  " Esc: Exit terminal mode
```

### **ShellHere** (Custom Function)

Opens an interactive shell in a split window at the current file's directory.

**Keybinding**:
```vim
<LocalLeader>ll  " Backslash-l-l: Open shell
```

**Features**:
- Auto-CD to current file's directory
- Remembers shell buffer between calls
- Exit with `Ctrl-d`

---

## Filetype-Specific Settings

```vim
augroup MyFiletypes
  autocmd!
  autocmd FileType tex      setlocal tabstop=2 shiftwidth=2 expandtab wrap linebreak spell
  autocmd FileType markdown setlocal wrap linebreak spell
  autocmd FileType gitcommit setlocal spell textwidth=72
augroup END
```

- **LaTeX (.tex)**: 2-space indent, word wrap, spell check
- **Markdown (.md)**: Word wrap, spell check
- **Git commits**: Spell check, 72-char line limit (conventional)

---

## Auto-Features

### **Trim Trailing Whitespace**
```vim
augroup TrimWhitespace
  autocmd!
  autocmd BufWritePre *.py,*.jl,*.rs,*.tex,*.md,*.sh %s/\s\+$//e
augroup END
```

Automatically removes trailing whitespace on save for code files.

### **Restore Cursor Position**
```vim
augroup RestoreCursor
  autocmd!
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   execute "normal! g`\"" |
        \ endif
augroup END
```

When reopening a file, cursor jumps to the last position (not line 1).

---

## Keybinding Reference

### **Global Custom Keys**

| Key | Command |
|-----|---------|
| ` ` (space) | Leader key |
| `\` | Local leader key |
| `jk` | Escape (insert mode) |
| `<Space>w` | Save |
| `<Space>q` | Quit |
| `<Space>Q` | Quit all (force) |
| `<C-q>` | Quit (all modes) |
| `<Space>h` | Clear search highlight |
| `<C-h/j/k/l>` | Move between splits |
| `<Space>s-v` | Vertical split |
| `<Space>s-h` | Horizontal split |
| `<Space>s-c` | Close split |
| `<Space>b-n` | Next buffer |
| `<Space>b-p` | Previous buffer |
| `<Space>b-d` | Delete buffer |
| `<Space>b-l` | List buffers |
| `<Alt-j/k>` | Move line up/down |
| `<Space>y` | Copy to clipboard |
| `<Space>p` | Paste from clipboard |
| `<C-d/u>` | Page down/up + center |
| `n` / `N` | Next/prev search + center |
| `<Space>s` | Interactive search/replace |
| `<Space>r` | Replace word under cursor |
| `<Space>v-c` | Open vimrc |
| `<Space>v-r` | Reload vimrc |
| `<Space>pdf` | View PDF (okular) |
| `<Space>l` | Plugin status |
| `<Space>a` | Install plugins |
| `<Space>c` | Clean plugins |
| `<Space>p-u` | Update plugins |

### **Plugin Keybindings**

| Key | Plugin | Action |
|-----|--------|--------|
| `<Space>e` | NERDTree | Toggle file tree |
| `<Space>f` | NERDTree | Find current file |
| `<Space>f-f` | FZF | Find files |
| `<Space>f-g` | FZF | Ripgrep search |
| `<Space>b` | FZF | Search buffers |
| `<Space>H` | FZF | Search history |
| `<Space>u` | Undotree | Toggle undo tree |
| `gd` | CoC | Go to definition |
| `gr` | CoC | Find references |
| `gi` | CoC | Go to implementation |
| `gy` | CoC | Go to type definition |
| `K` | CoC | Hover documentation |
| `<Space>rn` | CoC | Rename symbol |
| `<Space>ca` | CoC | Code actions |
| `[d` / `]d` | CoC | Prev/next diagnostic |
| `<Space>d` | CoC | Show diagnostics |
| `<LocalLeader>ll` | ShellHere | Open shell |
| `<C-d>` (terminal) | ShellHere | Exit terminal |

---

## Troubleshooting

### Plugin Installation Fails

**Problem**: vim-plug fails to download plugins

**Solution**:
```bash
# Ensure curl is installed
sudo pacman -S curl

# Manually re-run vim-plug
vim +PlugInstall +qall

# Check internet connection
curl https://github.com/
```

### CoC Not Working

**Problem**: Language completion doesn't activate

**Solution**:
1. Verify CoC is installed: `:PlugStatus`
2. Check language server: `:CocStatus`
3. Install language server:
   ```bash
   npm install -g pyright  # for Python
   ```
4. Configure CoC: `:CocConfig` and add language server settings

### FZF Not Finding Files

**Problem**: FZF shows no files or errors

**Solution**:
```bash
# Install ripgrep
sudo pacman -S ripgrep

# Verify it works
rg --files --hidden --follow --glob "!.git/*" .

# Then restart Vim
vim
```

### NERDTree Icons Not Showing

**Problem**: File icons appear as boxes or question marks

**Solution**:
1. Install a Nerd Font:
   ```bash
   sudo pacman -S nerd-fonts
   ```
2. Configure terminal to use Nerd Font (Terminal > Preferences > Font)
3. Restart Vim

### Slow Startup

**Problem**: Vim takes >2 seconds to start

**Solution**:
1. Disable lazy-loading plugins (not recommended):
   ```bash
   vim --startuptime startup.log
   # Check which plugins are slow
   ```
2. Comment out unused plugins in vimrc
3. Use `:PlugStatus` to verify all plugins are up-to-date

### Terminal Mode Not Working

**Problem**: Terminal keybindings don't respond

**Solution**:
1. Ensure Vim compiled with `+terminal`: `:echo has('terminal')`
2. Exit terminal mode with `Esc` (as configured)
3. Check Tmux configuration if using vim-slime

### LSP Diagnostics Spam

**Problem**: Too many error/warning highlights

**Solution**:
1. Configure severity levels in `:CocConfig`:
   ```json
   {
     "diagnostic.severity": "hint"
   }
   ```
2. Or disable for specific linters

---

## Performance Tips

1. **Increase syntax highlight limit for large files**:
   ```vim
   set synmaxcol=500  " Increase from 220
   ```

2. **Lazy-load heavy plugins**:
   ```vim
   Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
   ```

3. **Disable expensive features for large buffers**:
   ```vim
   autocmd BufReadPre * if getfsize(expand("%")) > 1000000 | setl norelativenumber | endif
   ```

4. **Profile startup**:
   ```bash
   vim --startuptime startup.log
   ```

---

## File Structure

```
~/.vim/
├── _vimrc                  # Main configuration (or ~/.vimrc)
├── autoload/
│   └── plug.vim            # vim-plug (auto-downloaded)
├── plugged/                # Installed plugins
│   ├── vim-sensible/
│   ├── vim-fugitive/
│   ├── coc.nvim/
│   └── ...
├── tmp/
│   ├── backup/             # Backup files
│   ├── swap/               # Swap files
│   └── undo/               # Undo history
└── ftplugin/               # Filetype-specific configs (optional)
```

---

## Contributing

Feel free to fork, customize, and adapt this configuration. Key areas:

- Add language servers to `:CocConfig`
- Add new plugins to the `call plug#begin()` block
- Customize keybindings to match your workflow
- Add filetype-specific settings to `augroup MyFiletypes`

---

## Quick Reference

### First Time Setup
```bash
git clone <repo> ~/.vim
vim
# Wait for vim-plug and plugins to install (~1-2 minutes)
```

### Daily Commands
```bash
# Open current directory
vim .

# Key operations:
# Space-e       → File tree (NERDTree)
# Space-f-f     → Find file (FZF)
# Space-f-g     → Search project (Ripgrep)
# Space-b       → Search buffers
# gd            → Go to definition (LSP)
# gr            → Find references
# Space-rn      → Rename
# Space-/       → Comment toggle
# Space-v-r     → Reload config
```

### Update Plugins
```vim
:PlugUpdate
:PlugUpgrade
```

### Check Health
```vim
:PlugStatus    " Check plugin status
:CocStatus     " Check language servers
```

---

## Credits

- Built with [Vim 8+](https://www.vim.org/) and [Neovim](https://neovim.io/)
- Plugin manager: [vim-plug](https://github.com/junegunn/vim-plug)
- Completion: [CoC (Conqueror of Completion)](https://github.com/neoclide/coc.nvim)
- Theme: [vim-monochrome](https://github.com/fxn/vim-monochrome)
