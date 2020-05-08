call plug#begin('~/.vim/plugged')

" color scheme
Plug 'dracula/vim', { 'as': 'dracula' }
" Plug 'jnurmine/Zenburn'
" Plug 'altercation/vim-colors-solarized'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" apperence
Plug 'bitc/vim-bad-whitespace' " Highlights whitespace at the end of lines, only in modifiable buffers
Plug 'tmhedberg/SimpylFold'
" to match indentation more closely what is suggested in PEP 8
Plug 'vim-scripts/indentpython.vim'  " An alternative indentation script for python
" Plug 'vim-syntastic/syntastic'  " Syntax checking hacks for vim
Plug 'Yggdroot/indentLine'  " A vim plugin to display the indention levels with thin vertical lines

Plug 'scrooloose/nerdtree'
" Plug 'jistr/vim-nerdtree-tabs'  " actually, vim provides tab feature
Plug 'tpope/vim-fugitive' " A Git wrapper

Plug 'ctrlpvim/ctrlp.vim' " find file
Plug 'mileszs/ack.vim' " code search, ack or ag is required to be installed
" Plug 'python-mode/python-mode'  " this plugin is very slow
" Plug 'Valloric/YouCompleteMe'  " this plugin is very slow
Plug 'mhinz/vim-signify'  " Show a diff using Vim its sign column
" autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'pedrohdz/vim-yaml-folds'  " yaml fold

if has('nvim')
    " Plug 'shougo/deoplete.nvim'
endif

" lint
Plug 'nvie/vim-flake8'

" distraction-free apperence, togger by :Goyo, :Goyo!(trun off)
Plug 'junegunn/goyo.vim'

" Initialize plugin system
call plug#end()


" Plugin configurations

"?? python with virtualenv support
py3 << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  exec(compile(open(activate_this, "rb").read(), activate_this, 'exec'), dict(__file__=activate_this))
EOF

" colorscheme
if has('gui_running')
  set background=dark
  colorscheme solarized
else
  " colorscheme zenburn
  " let g:dracula_italic = 0 " without this, the italic texts will be highlited
  colorscheme dracula
  color dracula
  " highlight Normal ctermbg=None " using system background
endif

""" Airline
let g:airline_theme='minimalist'
" alternative themes: molokai, deus, monochrome
" let g:airline#extensions#tabline#enabled = 1
set laststatus=2

""" nerdtree
map <C-n> :NERDTreeToggle<CR>
" open NERDTree automatically when vim starts up on opening a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
let NERDTreeIgnore=['.swp$', '\.pyc$', '__pycache__', '\~$'] "ignore files in NERDTree
let NERDTreeShowHidden=1
" let g:NERDTreeWinPos = "right"

" bad white space
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h
    \ match BadWhitespace /\s\+$/

""" YouCompleteMe
" let g:ycm_autoclose_preview_window_after_completion=1
" map <F2>  :YcmCompleter GoTo<CR>

""" deoplete.vim
" let g:deoplete#enable_at_startup = 1

""" COC
" autocomplete
let g:airline#extensions#coc#enabled = 1

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use `[c` and `]c` to navigate diagnostics
" nmap <silent> [c <Plug>(coc-diagnostic-prev)
" nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

""" ctrlp
" let g:ctrlp_dotfiles = 1
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = {
    \ 'dir':  'DS_Store\|\.venv\|\.venv3\|venv\|venv3\|\.git$\|\.hg$\|\.svn$\|bower_components$\|dist$\|node_modules$\|project_files$\|test$|__pycache__\',
    \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

""" ag or acg
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

""" SimpylFold
let g:SimpylFold_docstring_preview = 1
let g:SimpylFold_fold_docstring = 1
let b:SimpylFold_fold_docstring = 1
let g:SimpylFold_fold_import = 1

""" flake8

""" externals
" source ~/.sword/vim/pymode.vimrc

