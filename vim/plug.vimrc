
"?? python with virtualenv support
py3 << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  exec(compile(open(activate_this, "rb").read(), activate_this, 'exec'), dict(__file__=activate_this))
EOF

""" vim-plug
" install vim-plug if not installed automatically
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" fancy start screen
Plug 'mhinz/vim-startify'

"" apperence
" color scheme
" Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'morhetz/gruvbox', { 'as': 'gruvbox' }
" Plug 'jnurmine/Zenburn'
" Plug 'altercation/vim-colors-solarized'

Plug 'scrooloose/nerdtree'
" Plug 'jistr/vim-nerdtree-tabs'  " actually, vim provides tab feature

" fzf also has the feature of finding files
" Plug 'ctrlpvim/ctrlp.vim' " find file

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Highlights whitespace at the end of lines, only in modifiable buffers
Plug 'bitc/vim-bad-whitespace'
" too slow
Plug 'tmhedberg/SimpylFold'
" A vim plugin to display the indention levels with thin vertical lines
Plug 'Yggdroot/indentLine'

" to comment a line or block
Plug 'preservim/nerdcommenter'

" Plug 'vim-syntastic/syntastic'  " Syntax checking hacks for vim
Plug 'tpope/vim-fugitive' " A Git wrapper

Plug 'mhinz/vim-signify'  " Show a diff using Vim its sign column

" code search
" performance wise, ripgrep > silver search(ag) > ack > grep
" commented ripgrep because fzf also integrated ripgrep
" Plug 'jremmen/vim-ripgrep' " code search, ripgrep command is reqired to be installed beforehand
" Plug 'mileszs/ack.vim' " code search, ack or ag is required to be installed

" Plug 'python-mode/python-mode'  " this plugin is very slow

"" autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'Valloric/YouCompleteMe'  " this plugin is very slow

if has('nvim')
    " Plug 'shougo/deoplete.nvim'
endif

" distraction-free apperence, togger by :Goyo, :Goyo!(trun off)
" Plug 'junegunn/goyo.vim'

"" yaml
Plug 'pedrohdz/vim-yaml-folds'  " yaml fold

"" Python
" to match indentation more closely what is suggested in PEP 8
Plug 'vim-scripts/indentpython.vim'  " An alternative indentation script for python
" lint
Plug 'nvie/vim-flake8'

"" Go lang
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Initialize plugin system
call plug#end()


" Plugin configurations

" colorscheme
if has('gui_running')
  set background=dark
  colorscheme solarized
else
  " colorscheme zenburn
  " let g:dracula_italic = 0 " without this, the italic texts will be highlited
  " colorscheme dracula
  " color dracula
  colorscheme gruvbox
  color gruvbox
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
let NERDTreeIgnore=['.idea', '.DS_Store', '.swp$', '\.pyc$', '__pycache__', '\~$'] "ignore files in NERDTree
let NERDTreeShowHidden=1
" let g:NERDTreeWinPos = "right"

" bad white space
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h
    \ match BadWhitespace /\s\+$/

""" nerdcommenter
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Align line-wise comment delimiters flush left instead of following code indentation
" let g:NERDDefaultAlign = 'left'

""" YouCompleteMe
" let g:ycm_autoclose_preview_window_after_completion=1
" map <F2>  :YcmCompleter GoTo<CR>

""" deoplete.vim
" let g:deoplete#enable_at_startup = 1

""" COC
" autocomplete
let g:airline#extensions#coc#enabled = 1

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" alternatively, use <c-space>for trigger completion
" inoremap <silent><expr> <c-space> coc#refresh()

" Use <Tab> and <S-Tab> to navigate the completion list:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

"Use <cr> to confirm completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif " close preview window

" To make coc.nvim format your code on <cr>, use keymap:
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

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

""" ag or ack
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

""" fzf
nnoremap <silent> <C-f> :Files<CR>
" fzf integrated ripgrep
nnoremap <silent> <Leader>f :Rg<CR>
" Rg to not match files
command! -bang -nargs=* Rg
  \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

""" SimpylFold
" let g:SimpylFold_docstring_preview = 1
" let g:SimpylFold_fold_docstring = 1
" let b:SimpylFold_fold_docstring = 1
" let g:SimpylFold_fold_import = 1

""" Python
""" flake8

""" externals
" source ~/.sword/vim/pymode.vimrc

