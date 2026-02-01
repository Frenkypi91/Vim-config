# Vim-config

This repository contains my **Vim** configuration based on **vim-plug**, designed for an “IDE-like” workflow with:

- completion and LSP via **coc.nvim**
- linting + format-on-save via **ALE**
- fuzzy finder with **fzf** (+ `ripgrep`)
- file explorer **NERDTree**
- Git integration with **vim-gitgutter**
- snippets via **UltiSnips**
- support for **Python / Julia / R / LaTeX**
- fast code sending to **tmux** with **vim-slime**
- statusline with **vim-airline** + icons

> Note: this is for **Vim**, not Neovim.

---

## Minimum requirements

- **Vim 8.1+**
- `git`, `curl`
- Clipboard support recommended

---

## Installation

Copy `.vimrc` to your home directory and install **vim-plug**, then run `:PlugInstall`.

---

## External dependencies

- Base tools: git, curl, tmux, Nerd Font
- Search: fzf, ripgrep
- LSP: nodejs + npm
- LaTeX: TeX Live + **Okular**
- Clipboard: xclip / wl-clipboard

---

## Arch Linux example

(unchanged from original, translated)

---

## Keybindings

Leader key: **Space**

- `<Space>e` → toggle NERDTree
- `<Space>p` → Files
- `<Space>rg` → ripgrep search
- `<Space>ss` → send selection to tmux
