" Map leader to space, this should be before any <Leader> mappings
let mapleader=" "

" colorscheme
colorscheme challenger_deep

" make buffers hide automatically instead of needing to be asked
set hidden

" tab stuff
set tabstop=4

" wrap and linebreak
set linebreak
set showbreak=…

" undo stuff, for mundo
set undofile
set undodir=~/.config/nvim/undo

" For true color support
if has('nvim') || has('termguicolors')
  set termguicolors
endif

" lines
set number

" line highlight
set cursorline

" whitespace
set list
set listchars=tab:▸\ ,trail:•,nbsp:•

" ignored directories in grep
set wildignore+=node_modules/**,target/**

" enable mouse
set mouse=a

" width till wrapping
set textwidth=80

" use 'par' for better formatting, see: http://www.nicemice.net/par/
set formatprg=par

" preview window height (i.e. Gstatus window)
set previewheight=16

" disable python2
let g:loaded_python_provider = 1

" useful things
" Use this command to write things as sudo: `:w !sudo tee %`
