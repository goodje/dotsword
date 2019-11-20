" python-mode configurations

let g:pymode_python = 'python3' " default is python2

" plugin's warnings
let g:pymode_warnings = 1

" Rope refactoring operations
let g:pymode_rope=0

"""" turn off autocomplete
let g:pymode_rope_completion = 0
let g:pymode_rope_complete_on_dot = 0
let g:pymode_rope_autoimport = 0

let g:pymode_lint_on_write = 0 " turn off lint

" colorcolumn display at max_line_length
let g:pymode_options_colorcolumn = 1

" setup max line length
let g:pymode_options_max_line_length = 120

" Pymode supports PEP8-compatible python indent.
" Enable pymode indentation
" let g:pymode_indent = 1

" Currently folding is considered experimental.
" There are several issues with its implementation.
let g:pymode_folding = 0
" fold shortcuts https://stackoverflow.com/questions/23579058/vim-python-mode-folding

" Enable pymode-motion
let g:pymode_motion = 1

"Enable automatic virtualenv detection
let g:pymode_virtualenv = 1
" Set path to virtualenv manually, (path can be absolute or relative to current working directory)
" let g:pymode_virtualenv_path = '.venv'

nnoremap <C-c>g :RopeGotoDefinition<cr>
let g:pymode_rope_goto_definition_cmd = 'new'

" pymode syntax
let g:pymode_syntax = 0
" Slower syntax synchronization that is better at handling code blocks in docstrings
" let g:pymode_syntax_slow_sync = 1
" all python highlights
" let g:pymode_syntax_all = 1

"""""" Reference

