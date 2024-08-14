
"?? auto activate virtualenv, it requires pyvim or pynvim
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

" fancy start screen
Plug 'mhinz/vim-startify'

"" apperence
" status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" color scheme
" Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'morhetz/gruvbox', { 'as': 'gruvbox' }
" Plug 'jnurmine/Zenburn'
" Plug 'altercation/vim-colors-solarized'

" file navigator/explorer
if has('nvim')
  Plug 'nvim-tree/nvim-web-devicons' " optional
  Plug 'kyazdani42/nvim-tree.lua'

  Plug 'ibhagwan/fzf-lua', {'branch': 'main'}

  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

  "" LSP
  Plug 'neovim/nvim-lspconfig'

  "" completion
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'

  " For vsnip users.
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/vim-vsnip'

  "" Golang
  Plug 'ray-x/go.nvim'
  Plug 'ray-x/guihua.lua' " recommended if need floating window support

else
  Plug 'preservim/nerdtree'

  "" fzf also has the feature of finding files
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  "" Golang
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

endif

" Plug 'jistr/vim-nerdtree-tabs'  " actually, vim provides tab feature

" Plug 'ctrlpvim/ctrlp.vim' " find file

" code search
" performance wise, ripgrep > silver search(ag) > ack > grep
" commented ripgrep because fzf also integrated ripgrep
" Plug 'jremmen/vim-ripgrep' " code search, ripgrep command is reqired to be installed beforehand
" code search, ack or ag is required to be installed
" Plug 'mileszs/ack.vim' " code search, ack or ag is required to be installed

" Plug 'python-mode/python-mode'  " this plugin is very slow

"" edit
" Highlights whitespace at the end of lines, only in modifiable buffers
Plug 'bitc/vim-bad-whitespace'
Plug 'tmhedberg/SimpylFold' " too slow
" A vim plugin to display the indention levels with thin vertical lines
Plug 'Yggdroot/indentLine'

" to comment a line or block
Plug 'preservim/nerdcommenter'

Plug 'preservim/tagbar'

" Plug 'vim-syntastic/syntastic'  " Syntax checking hacks for vim
" A Git wrapper
Plug 'tpope/vim-fugitive'

" fugitive plugin for Growser
" Github
Plug 'tpope/vim-rhubarb'
" Gitlab
Plug 'shumphrey/fugitive-gitlab.vim'

" Show file changes(based on VCS) using Vim its sign column
Plug 'mhinz/vim-signify'

" Plug 'Shougo/ddc.vim'
" Plug 'vim-denops/denops.vim'

" Plug 'Valloric/YouCompleteMe'  " this plugin is very slow

if has('nvim')
"  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  " Plug 'Shougo/deoplete.nvim'
"  Plug 'roxma/nvim-yarp'
"  Plug 'roxma/vim-hug-neovim-rpc'
endif

if has('pythonx')
    if has('python3')
        set pyxversion=3
    else
        set pyxversion=2
    endif
endif
"let g:deoplete#enable_at_startup = 1

Plug 'github/copilot.vim'

" distraction-free apperence, togger by :Goyo, :Goyo!(trun off)
" Plug 'junegunn/goyo.vim'

"" yaml
" yaml fold
Plug 'pedrohdz/vim-yaml-folds'

"" Python
" to match indentation more closely what is suggested in PEP 8
" An alternative indentation script for python
Plug 'vim-scripts/indentpython.vim'
" lint
Plug 'nvie/vim-flake8'

"" UML
Plug 'aklt/plantuml-syntax'
" uml preview in vim, Java is required
Plug 'scrooloose/vim-slumlord'

Plug 'tyru/open-browser.vim'

" PlantUML previewer in browser
Plug 'weirongxu/plantuml-previewer.vim'

"" PHP
" Include Phpactor
" Plug 'phpactor/phpactor' ,  {'do': 'composer install', 'for': 'php'}

" Require ncm2 and this plugin
" Plug 'ncm2/ncm2'
" Plug 'roxma/nvim-yarp'
" Plug 'phpactor/ncm2-phpactor'

" Javascript(js)/Typescript(ts)
Plug 'posva/vim-vue'

" JS ORM framework
" Plug 'prisma/vim-prisma'

" post install (yarn install | npm install) then load plugin only for editing supported files
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install --frozen-lockfile --production',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'] }

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
  let g:gruvbox_italic=1
  let g:gruvbox_contrast_dark='hard'
  set background=dark
  colorscheme gruvbox
  color gruvbox
  " highlight Normal ctermbg=None " using system background
endif

""" Airline
let g:airline_theme='minimalist'
" alternative themes: molokai, deus, monochrome
" let g:airline#extensions#tabline#enabled = 1
set laststatus=2

if has('nvim')
  " nvim is uses nvim-tree instead of NERDTree
  map	<C-n> :NvimTreeToggle<CR>
  " focus in nvim-tree window and move the cusor to the file
  " l for locate
  map <leader>l :NvimTreeFindFile<cr>

else " vim

  "" autocomplete
  filetype plugin on
  set omnifunc=syntaxcomplete#Complete

  """ nerdtree settings
  map <C-n> :NERDTreeToggle<CR>
  " open NERDTree automatically when vim starts up on opening a directory
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
  " ignore files in NERDTree
  let NERDTreeIgnore=['.idea', '.DS_Store', '.swp$', '\.pyc$', '__pycache__', '\~$']
  let NERDTreeShowHidden=1
  " let g:NERDTreeWinPos = "right"
  " focus in NERDTree window and move the cusor to the file
  map <leader>l :NERDTreeFind<cr>
endif

""" indentLine

" bad white space
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h
    \ match BadWhitespace /\s\+$/

""" nerdcommenter
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Align line-wise comment delimiters flush left instead of following code indentation
" let g:NERDDefaultAlign = 'left'

let g:go_code_completion_enabled = 1
let g:go_gopls_complete_unimported = v:null
let g:go_gopls_deep_completion = v:null


""" YouCompleteMe
" let g:ycm_autoclose_preview_window_after_completion=1
" map <F2>  :YcmCompleter GoTo<CR>

""" deoplete.vim
" let g:deoplete#enable_at_startup = 1

if !has('nvim')
  """ COC
  source  ~/.sword/vim/coc.vimrc
endif


""" ctrlp
" let g:ctrlp_dotfiles = 1
" let g:ctrlp_show_hidden = 1
" let g:ctrlp_custom_ignore = {
"     \ 'dir':  'DS_Store\|\.venv\|\.venv3\|venv\|venv3\|\.git$\|\.hg$\|\.svn$\|bower_components$\|dist$\|node_modules$\|project_files$\|test$|__pycache__\',
"     \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

""" ag or ack
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

if has('nvim')
else
  """ fzf
  nnoremap <silent> <C-f> :Rg<CR>
  " fzf integrated ripgrep
  nnoremap <silent> <Leader>f :Files<CR>
  " Rg to not match files
  command! -bang -nargs=* Rg
    \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)
  nnoremap <silent> <Leader>b :Buffers<CR>
endif

""" SimpylFold
" let g:SimpylFold_docstring_preview = 1
" let g:SimpylFold_fold_docstring = 1
" let b:SimpylFold_fold_docstring = 1
" let g:SimpylFold_fold_import = 1

""" Python
""" flake8

"""
" source ~/.sword/vim/pymode.vimrc
"

"" vim-go

" Go syntax highlighting
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1

" Status line types/signatures
let g:go_auto_type_info = 1

" Opening Documentation in a Popup, use K to trigger it
let g:go_doc_popup_window = 1

augroup GoSettings
  " most used
  " nmap <silent> gi :GoImplements<cr>
  " nmap <silent> gr :GoReferrers<cr>
  autocmd filetype go nmap <silent> gc :GoCallers<cr>

  " autocomplete prompt to appear automatically whenever you press the dot (.)
  " use Ctrl-n or Ctrl-p to select
  autocmd filetype go inoremap <buffer> . .<C-x><C-o>

augroup END

" autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect


" C/C++
augroup CSettings
  autocmd!

  if has('python')
    autocmd filetype c,cpp map <C-K> :pyf /usr/share/clang/clang-format-15/clang-format.py<cr> |
      \imap <C-K> <c-o>:pyf /usr/share/clang/clang-format-15/clang-format.py<cr>
  elseif has('python3')
    autocmd filetype c,cpp map <C-K> :py3f /usr/share/clang/clang-format-15/clang-format.py<cr> |
      \imap <C-K> <c-o>:py3f /usr/share/clang/clang-format-15/clang-format.py<cr>
  endif

  function! FormatOnSave()
    let l:formatdiff = 1
    if has('python')
      pyf /opt/homebrew/share/clang/clang-format.py
    elseif has('python3')
      py3f /opt/homebrew/share/clang/clang-format.py
    endif
  endfunction
  autocmd BufWritePre *.c,*.h,*.cc,*.cpp call FormatOnSave()

  " set updatetime=300
  " au CursorHold *.c,*.h sil call CocActionAsync('highlight')
  au CursorHoldI *.c,*.h sil call CocActionAsync('showSignatureHelp')


  " bases
  nn <silent> xb :call CocLocations('ccls','$ccls/inheritance')<cr>
  " bases of up to 3 levels
  nn <silent> xB :call CocLocations('ccls','$ccls/inheritance',{'levels':3})<cr>
  " derived
  nn <silent> xd :call CocLocations('ccls','$ccls/inheritance',{'derived':v:true})<cr>
  " derived of up to 3 levels
  nn <silent> xD :call CocLocations('ccls','$ccls/inheritance',{'derived':v:true,'levels':3})<cr>

  " caller
  nn <silent> xc :call CocLocations('ccls','$ccls/call')<cr>
  " callee
  nn <silent> xC :call CocLocations('ccls','$ccls/call',{'callee':v:true})<cr>

  " $ccls/member
  " member variables / variables in a namespace
  nn <silent> xm :call CocLocations('ccls','$ccls/member')<cr>
  " member functions / functions in a namespace
  nn <silent> xf :call CocLocations('ccls','$ccls/member',{'kind':3})<cr>
  " nested classes / types in a namespace
  nn <silent> xs :call CocLocations('ccls','$ccls/member',{'kind':2})<cr>

  nmap <silent> xt <Plug>(coc-type-definition)<cr>
  nn <silent> xv :call CocLocations('ccls','$ccls/vars')<cr>
  nn <silent> xV :call CocLocations('ccls','$ccls/vars',{'kind':1})<cr>

  nn xx x

  nn <silent><buffer> <C-l> :call CocLocations('ccls','$ccls/navigate',{'direction':'D'})<cr>
  nn <silent><buffer> <C-k> :call CocLocations('ccls','$ccls/navigate',{'direction':'L'})<cr>
  nn <silent><buffer> <C-j> :call CocLocations('ccls','$ccls/navigate',{'direction':'R'})<cr>
  nn <silent><buffer> <C-h> :call CocLocations('ccls','$ccls/navigate',{'direction':'U'})<cr>

augroup END

" for prettier plugin, it auto format after saving
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0 " not matter if there is "@format" or "@prettier" tag in the file

