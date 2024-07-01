" Map leader to space, this should be before any <Leader> mappings
let mapleader=" "
let maplocalleader="\\"

" colorscheme
syntax enable
colorscheme palenight

" palenight
let g:palenight_terminal_italics=1
hi DiffAdd      gui=none guifg=NONE    guibg=#2e4730
hi DiffChange   gui=none guifg=NONE    guibg=#47452e
hi DiffDelete   gui=bold guifg=#a02e2e guibg=#472e2e
hi DiffText     gui=none guifg=NONE    guibg=#2e4047
hi Search       gui=none guifg=black   guibg=#61ceec
hi CocInlayHint gui=none guifg=#474d6c guibg=NONE

" make buffers hide automatically instead of needing to be asked
set hidden

" tab stuff
set tabstop=2
set softtabstop=2
set shiftwidth=2

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

" Remove comment leader when joining comment lines
set formatoptions+=j
" Insert the comment leader after hitting <Enter> in insert mode
set formatoptions+=r
" Smart format inside of numbered lists
set formatoptions+=n

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

" pop up menu
set wildmode=longest:full
set wildoptions=pum
set pumblend=10

" diff options
" set diffopt+=iwhiteall
set diffopt+=internal,algorithm:histogram

" pyx stuff
if has('python3')
  set pyx=3
elseif has('python2')
  set pyx=2
endif

" turn off modelines until we need them
set nomodeline

" specify gx bin
" let g:netrw_browsex_viewer = "explorer.exe"

" sbt filetype to scala
au BufRead,BufNewFile *.sbt set filetype=scala

" smart case search
set smartcase
