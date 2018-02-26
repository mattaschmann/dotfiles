" my plugins: see https://github.com/junegunn/vim-plug
call plug#begin()

" theme
Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep-theme' }
" easily move around
Plug 'easymotion/vim-easymotion'
" show the yank
Plug 'haya14busa/vim-operator-flashy'
" dep for flash
Plug 'kana/vim-operator-user'
" fuzzy search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" git integration
Plug 'tpope/vim-fugitive'
" smart set shiftwidth
Plug 'tpope/vim-sleuth'
" make changing surrounds easier
Plug 'tpope/vim-surround'
" make comments easier
Plug 'tpope/vim-commentary'
" bottom status bar
Plug 'vim-airline/vim-airline'
" filetree
Plug 'scrooloose/nerdtree'
" auto make close pairs
Plug 'jiangmiao/auto-pairs'
" linting
Plug 'vim-syntastic/syntastic'
" rust lang for syntastic
Plug 'rust-lang/rust.vim'
" exchange two things
Plug 'tommcdo/vim-exchange'
" intellisense
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

call plug#end()

" Edit vim-airline
" let g:airline_section_y = '%{&g:airline_section_y} %{&shiftwidth}'
function! AirlineInit()
  call airline#parts#define_raw('shiftwidth', 'sw:%{&shiftwidth}')
  let g:airline_section_y = airline#section#create_right(['ffenc', 'shiftwidth'])
endfunction
autocmd VimEnter * call AirlineInit()

" colorscheme
colorscheme challenger_deep

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

" Syntastic stuff
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 2
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1
let g:syntastic_enable_signs = 0
" let g:syntastic_error_symbol = '->'
" Syntastic checker stuff
let g:syntastic_rust_checkers = ['cargo']

" Map leader to space, this should be before any <Leader> mappings
let mapleader=" "

" NERDTree mappings
nnoremap <C-\> :NERDTreeToggle<CR>
nnoremap <Leader>0 :NERDTreeFind<CR>

" Like command palette
if exists(':FZF') == 2
  nnoremap <Leader><C-p> :Commands<CR>
endif

"This unsets the "last search pattern" register by hitting return
nnoremap <Leader>n :noh<CR>

" For the flashy plugin
map y <Plug>(operator-flashy)
nmap Y <Plug>(operator-flashy)$

" location window mappins
nmap <Leader>. :lne<CR>
nmap <Leader>, :lpr<CR>
