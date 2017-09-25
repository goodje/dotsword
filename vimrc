"""" basic setup
" Use vim settings, rather then vi settings (much better!)
" This must be first, because it changes other options as a side effect.
set nocompatible

"" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set bomb
set binary
set ttyfast

"""" appearance
syntax on
set number
set showcmd             " show command in bottom bar
" set cursorline          " highlight current line
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to.
set ruler
set t_Co=256
set guioptions=egmrti

"""" tab, indent
set nowrap
set tabstop=4                   " a tab is four spaces
set softtabstop=4               " when hitting <BS>, pretend like a tab is removed, even if spaces
set shiftwidth=4                " number of spaces to use for autoindenting
set expandtab
set smarttab                    " insert tabs on the start of a line according to shiftwidth, not tabstop
set autoindent                  " always set autoindenting on

set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default

"""" search
set showmatch
set hlsearch
nnoremap <silent> <Esc> :nohlsearch<Bar>:echo<CR>

"""" misc
" set hidden
set history=1024

" set colorcolumn=120
call matchadd("ColorColumn", '\%81v', 120)
highlight ColorColumn ctermbg=8 guibg=lightgrey

set fileformats="unix,dos,mac"

set mouse=

" change cursor from block to vertical line, allows cursor change in tmux mode
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif


"""" reference
" A Good Vimrc https://dougblack.io/words/a-good-vimrc.html
