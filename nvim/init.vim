" Installation of vim-plug package manager
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Install vim plugins
call plug#begin('~/.vim/plugged')

" Lua utilities
Plug 'nvim-lua/plenary.nvim'

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
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
" Auto closing of brackets, quotes, etc.
Plug 'windwp/nvim-autopairs'
Plug 'windwp/nvim-ts-autotag'
" Auto complete
Plug 'hrsh7th/nvim-cmp' " autocomplete tool
Plug 'onsails/lspkind.nvim' "vs-code like icons for autocompletion
" cmp content plugins
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
" Language Server
Plug 'neovim/nvim-lspconfig' "default language server config
Plug 'hrsh7th/cmp-nvim-lsp'
" Snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'

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
lua << END
require('lualine').setup()
require("nvim-autopairs").setup {}
require('gitsigns').setup()
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
local lspkind = require('lspkind')

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end
  },
  window = {},
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol',
      maxwidth = 50,
      ellipsis_char = '...',
      before = function (entry, vim_item)
        return vim_item
      end
    })
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
    { name = 'buffer' },
    { name = 'path'},
  })
})
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- The following example advertise capabilities to `clangd`.
require'lspconfig'.clangd.setup {
  capabilities = capabilities,
}

local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.code_actions.gitsigns,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.completion.spell,
    },
})

require'nvim-treesitter.configs'.setup {
  ensure_installed = {"lua", "javascript", "go", "json", "yaml", "typescript", "markdown", "html", "java", "gitignore", "gitattributes", "dockerfile"},

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = {},

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

require'nvim-treesitter.configs'.setup {
  autotag = {
    enable = true,
  }
}
END
