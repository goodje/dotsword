" python-mode configurations

" let g:pymode_python = 'python3' # default is python2

"""" turn off autocomplete
let g:pymode_rope_complete_on_dot = 0
let g:pymode_rope_completion = 0


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

"Enable automatic virtualenv detection
let g:pymode_virtualenv = 1
" Set path to virtualenv manually, (path can be absolute or relative to current working directory)
" let g:pymode_virtualenv_path = '.venv'

