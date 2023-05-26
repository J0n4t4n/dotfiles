" Installation of vim-plug package manager
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Install vim plugins
call plug#begin('~/.vim/plugged')

" Lua utilities
Plug 'nvim-lua/plenary.nvim'

" Managing & Installing LSP servers, linters & formatters
Plug 'williamboman/mason.nvim', { 'do': ':MasonUpdate'}
Plug 'williamboman/mason-lspconfig.nvim' " bridges gap b/w mason & lspconfig
Plug 'jayp0521/mason-null-ls.nvim' " bridges gab b/w mason & null-ls
" Language Server
Plug 'neovim/nvim-lspconfig' "default language server config
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'glepnir/lspsaga.nvim'
Plug 'jose-elias-alvarez/typescript.nvim'

" Formatting Linting
Plug 'jose-elias-alvarez/null-ls.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Vim Powerline Styling
Plug 'nvim-lualine/lualine.nvim'
Plug 'ryanoasis/vim-devicons'
"Plug 'itchyny/lightline.vim'
Plug 'bluz71/vim-nightfly-guicolors'
" Git Support
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'
" File explorer
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
" Auto closing of brackets, quotes, etc.
Plug 'windwp/nvim-autopairs'
Plug 'windwp/nvim-ts-autotag'
" Auto complete
Plug 'hrsh7th/nvim-cmp' " autocomplete tool
Plug 'onsails/lspkind.nvim' "vs-code like icons for autocompletion
" cmp content plugins
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
" Snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'

Plug 'mthbernardes/codeexplain.nvim'
Plug 'folke/which-key.nvim'

call plug#end()

" Show linenumbers
set number
set relativenumber

" Avoid wrapping a line in the middle of a word
set linebreak

" Configure automatic indentation
set autoindent      " Inherit indentation from previous lines
set expandtab       " Expand tabs to spaces
set shiftwidth=2    " Indent two spaces when shifting
set smarttab        " Insert 'tabstop' spaces when tab is pressed
set tabstop=2       " Indent four spaces
filetype indent on  " Use file-type specific indentation rules

set cursorline

set termguicolors
colorscheme nightfly

" Configure persistent undo
set undodir=~/.vim/temp_dirs/undodir
set undofile
set undolevels=500
set undoreload=2000

" Use clipboard for all operations
" Don't use + and * registers
" Needs xclip or other (:h clipboard)
set clipboard+=unnamedplus

" Set timeout for WhichKey
set timeoutlen=250

" Configure NerdTree git symbols
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ "Modified"  : "M",
    \ "Staged"    : "✚",
    \ "Untracked" : "?",
    \ "Renamed"   : "R",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "D",
    \ "Dirty"     : "!",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : 'i',
    \ "Unknown"   : "u"
    \ }
let g:NERDTreeGitStatusShowIgnored = 1

" Window switching keybinds
"nnoremap <C-Up> <C-W><Up>
"nnoremap <C-Down> <C-W><Down>
"nnoremap <C-Left> <C-W><Left>
"nnoremap <C-Right> <C-W><Right>
map <C-n> :NERDTreeToggle<CR>

" Reload file on window focus
au FocusGained,BufEnter * :silent! !

" Exit Vim if only Nerdtree is left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" On save of init.vim reload settings
au BufWritePost init.vim source $MYVIMRC

au BufNewFile,BufRead,BufEnter	*.md	setlocal spell	spelllang=en_us,de_de
au BufNewFile,BufRead,BufEnter	*.txt	setlocal spell	spelllang=en_us,de_de
au BufNewFile,BufRead,BufEnter	README	setlocal spell	spelllang=en_us
" au BufWritePost			*.md	!pandoc -o "<afile>:p:r.pdf" "<afile>:p"

"au BufWritePost *beamer.md silent! !pandoc -s -t beamer --slide-level 2 -o "<afile>:p:r.pdf" "<afile>:p"

" Lualine Config
" Based on: https://github.com/josean-dev/dev-environment-files
lua << END
require('jonatan.plugins.nvim-cmp')
require('jonatan.plugins.which-key')
require('jonatan.plugins.lualine')
require('jonatan.plugins.autopairs')
require('jonatan.plugins.treesitter')
require('jonatan.plugins.lsp.lspconfig')
require('jonatan.plugins.lsp.lspsaga')
require('jonatan.plugins.lsp.mason')
require('jonatan.plugins.lsp.null-ls')
require('jonatan.plugins.lsp.mason-null-ls')
-- require('jonatan.plugins.gitsigns')
END
