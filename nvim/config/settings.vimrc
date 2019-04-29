" Map leader to space, this should be before any <Leader> mappings
let mapleader=" "
let maplocalleader="\\"

" colorscheme
colorscheme challenger_deep

" make buffers hide automatically instead of needing to be asked
set hidden

" tab stuff
set tabstop=4

" wrap and linebreak
set linebreak
set showbreak=…
set breakindent

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
set listchars=tab:»\ ,trail:•,nbsp:•

" ignored directories in grep
set wildignore+=node_modules/**,target/**

" enable mouse
set mouse=a

" use 'par' for better formatting, see: http://www.nicemice.net/par/
set formatprg=par

" preview window height (i.e. Gstatus window)
set previewheight=16

" disable python2
let g:loaded_python_provider = 1

" For conceal markers.
if has('conceal')
  " set conceallevel=2 concealcursor=niv
  set conceallevel=2
endif

" Don't add the comment prefix automatically in certain files
au FileType vim setlocal fo-=r fo-=o

" Update time, default is 4secs (4000)
set updatetime=500

" always show context when scrolling
set scrolloff=2
set sidescrolloff=2

" show live preview of substitute
set inccommand=split

" Set textwidth automatically for certain files
au FileType markdown,text setlocal textwidth=80

" Term cursor
hi! TermCursorNC ctermfg=15 guifg=#fdf6e3 ctermbg=14 guibg=#93a1a1 cterm=NONE gui=NONE

" Remove comment leader when joining comment lines
set formatoptions+=j
" Insert the comment leader after hitting <Enter> in insert mode
set formatoptions+=r
" Smart format inside of numbered lists
set formatoptions+=n

" Catch focus events and refresh file
autocmd BufEnter,FocusGained * checktime

" Edit some of the short message settings
set shortmess+=A        " Dont show the ATTENTION message
set shortmess+=I        " Don't show the intro message, as it disappears anyway

" Open links in currently open buffers
set switchbuf=usetab

" Allow unconstrained movement in visual block mode
set virtualedit=block

" Make a permanent sign column to get rid of jumpiness
set signcolumn=yes

" turn off showmode
set noshowmode

" don't use the preview menu on completions
set completeopt-=preview

" enable closing of netrw windows
autocmd FileType netrw setl bufhiden=wipe

" pop up menu
set wildmode=longest:full
set wildoptions=pum
set pumblend=10

" diff options
" set diffopt+=iwhiteall
set diffopt+=internal,algorithm:histogram
