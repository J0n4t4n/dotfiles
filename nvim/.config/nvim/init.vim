" Installation of vim-plug package manager
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Install function for vim-markdown-composer
function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release --locked
    else
      !cargo build --release --locked --no-default-features --features json-rpc
    endif
  endif
endfunction

" Install vim plugins
call plug#begin('~/.vim/plugged')

" Vim Powerline Styling (buttom and top bar)
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Git Support
Plug 'tpope/vim-fugitive'
" File explorer
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
" Language completion
Plug 'Valloric/YouCompleteMe'
" Auto closing of brackets, quotes, etc.
Plug 'raimondi/delimitmate'
" Syntax Checking with Rust Support
Plug 'vim-syntastic/syntastic'
Plug 'rust-lang/rust.vim'
" Markdown Preview
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }

call plug#end()

" Disabled as I forgot what it does
" set laststatus=2

" Show linenumbers
" Current: Absolute
" Other: Relative to current
set number
set relativenumber

" Avoid wrapping a line in the middle of a word
set linebreak

" Configure automatic indentation
set autoindent      " Inherit indentation from previous lines
set expandtab       " Expand tabs to spaces
set shiftwidth=4    " Indent four spaces when shifting
set smarttab        " Insert 'tabstop' spaces when tab is pressed
set tabstop=4       " Indent four spaces
filetype indent on  " Use file-type specific indentation rules

" Configure persistent undo
set undodir=~/.vim/temp_dirs/undodir
set undofile
set undolevels=500
set undoreload=2000

" Use clipboard for all operations
" Don't use + and * registers
" Needs xclip or other (:h clipboard)
set clipboard+=unnamedplus

" Run rustfmt on save
let g:rustfmt_autosave = 1

" Select airline theme
let g:airline_theme='powerlineish'
let g:airline_powerline_fonts = 1
" Activate upper tabline and set styling
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

" Configure NerdTree git symbols
let g:NERDTreeIndicatorMapCustom = {
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
let g:NERDTreeShowIgnoredStatus = 1

" Markdown Preview use surf browser
let g:markdown_composer_browser = "surf"

" Window switching keybinds
nnoremap <C-Up> <C-W><Up>
nnoremap <C-Down> <C-W><Down>
nnoremap <C-Left> <C-W><Left>
nnoremap <C-Right> <C-W><Right>
map <C-n> :NERDTreeToggle<CR>

" Bugged?
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

" Always fill error list
let g:syntastic_always_populate_loc_list = 1
" Don't automatically open error list
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Reload file on window focus
au FocusGained,BufEnter * :silent! !

" Exit Vim if only Nerdtree is left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" On save of init.vim reload settings
au BufWritePost init.vim source $MYVIMRC

" au BufNewFile,BufRead,BufEnter	*.md	setlocal spell	spelllang=en_us,de_de
au BufNewFile,BufRead,BufEnter	*.txt	setlocal spell	spelllang=en_us,de_de
au BufNewFile,BufRead,BufEnter	README	setlocal spell	spelllang=en_us
" au BufWritePost			*.md	!pandoc -o "<afile>:p:r.pdf" "<afile>:p"

au BufWritePost *beamer.md silent! !pandoc -s -t beamer --slide-level 2 -o "<afile>:p:r.pdf" "<afile>:p"
