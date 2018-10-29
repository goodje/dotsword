" refer to https://github.com/VundleVim/Vundle.vim

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'ctrlpvim/ctrlp.vim' " find file
Plugin 'mhinz/vim-signify'  " Show a diff using Vim its sign column
" Plugin 'python-mode/python-mode'
" Plugin 'Valloric/YouCompleteMe'
Plugin 'mileszs/ack.vim' " code search, ack or ag is required to be installed
Plugin 'tmhedberg/SimpylFold'
" to match indentation more closely what is suggested in PEP 8
Plugin 'vim-scripts/indentpython.vim'  " An alternative indentation script for python
" Plugin 'vim-syntastic/syntastic'  " Syntax checking hacks for vim
Plugin 'nvie/vim-flake8'

" color scheme
Plugin 'dracula/vim'
" Plugin 'jnurmine/Zenburn'
" Plugin 'altercation/vim-colors-solarized'

" apperence
Plugin 'scrooloose/nerdtree'
" Plugin 'jistr/vim-nerdtree-tabs'  " actually, vim provides tab feature
Plugin 'tpope/vim-fugitive' " A Git wrapper
Plugin 'bitc/vim-bad-whitespace' " Highlights whitespace at the end of lines, only in modifiable buffers
Plugin 'Yggdroot/indentLine'  " A vim plugin to display the indention levels with thin vertical lines

if has('nvim')
    Plugin 'shougo/deoplete.nvim'
endif

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

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

""" YouCompleteMe
" let g:ycm_autoclose_preview_window_after_completion=1
" map <F2>  :YcmCompleter GoTo<CR>

""" deoplete.vim
let g:deoplete#enable_at_startup = 1

""" ctrlp
let g:ctrlp_custom_ignore = {
    \ 'dir':  'DS_Store\|\.git$\|\.hg$\|\.svn$\|bower_components$\|dist$\|node_modules$\|project_files$\|test$|__pycache__\',
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

""" externals
" source ~/.sword/vim/pymode.vimrc

