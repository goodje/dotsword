" Use vim settings, rather then vi settings (much better!)
" This must be first, because it changes other options as a side effect.
set nocompatible

syntax on

set number
set tabstop=4                   " a tab is four spaces
set softtabstop=4               " when hitting <BS>, pretend like a tab is removed, even if spaces
set shiftwidth=4                " number of spaces to use for autoindenting
set expandtab
set smarttab                    " insert tabs on the start of a line according to shiftwidth, not tabstop
set autoindent                  " always set autoindenting on

set fileformats="unix,dos,mac"


set mouse=
