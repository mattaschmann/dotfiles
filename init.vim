" my plugins: see https://github.com/junegunn/vim-plug
call plug#begin()

Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep-theme' }
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/vim-operator-flashy'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'kana/vim-operator-user'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'vim-airline/vim-airline'
Plug 'scrooloose/nerdtree'
Plug 'jiangmiao/auto-pairs'
Plug 'vim-syntastic/syntastic'
Plug 'rust-lang/rust.vim'
Plug 'tommcdo/vim-exchange'

call plug#end()

" For the flashy plugin
map y <Plug>(operator-flashy)
nmap Y <Plug>(operator-flashy)$

" Like command palette
if exists(':FZF') == 2
  nnoremap <Leader><C-p> :Commands<CR>
endif

" Edit vim-airline
" let g:airline_section_y = '%{&g:airline_section_y} %{&shiftwidth}'
function! AirlineInit()
  call airline#parts#define_raw('shiftwidth', 'sw:%{&shiftwidth}')
  let g:airline_section_y = airline#section#create_right(['ffenc', 'shiftwidth'])
endfunction
autocmd VimEnter * call AirlineInit()

"This unsets the "last search pattern" register by hitting return
nnoremap <Leader>n :noh<CR>

" colorscheme
colorscheme challenger_deep

" Map leader to space
let mapleader=" "

" make buffers hide automatically instead of needing to be asked
set hidden

" tab stuff
set tabstop=4

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

" FZF stuff
" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" ignored directories in grep
set wildignore+=node_modules/**,target/**

" enable mouse
set mouse=a

" spelling
" setlocal spell spelllang=en_us

" NERDTree mappings
nnoremap <C-\> :NERDTreeToggle<CR>
nnoremap <Leader>0 :NERDTreeFind<CR>

