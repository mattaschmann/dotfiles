" Windows specific shell stuff
" set shell=powershell
" set shellcmdflag=-command

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
" fuzzy search: is made better with the_silver_searcher
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
" use repeat with plugins
Plug 'tpope/vim-repeat'
" some nice keyboard mappings (including bubbling)
Plug 'tpope/vim-unimpaired'
" bottom status bar
Plug 'vim-airline/vim-airline'
" filetree
Plug 'scrooloose/nerdtree'
" auto make close pairs
Plug 'jiangmiao/auto-pairs'
" exchange two things
Plug 'tommcdo/vim-exchange'
" async linting
Plug 'w0rp/ale'
" async completion
Plug 'maralla/completor.vim'
" typescript syntax
Plug 'leafgarland/typescript-vim'
" tsserver
Plug 'maralla/completor-typescript'
" bracket matching
Plug 'luochen1990/rainbow'
" autoformant, i.e. beautify
Plug 'Chiel92/vim-autoformat'
" javascript syntax
Plug 'pangloss/vim-javascript'
" jsx syntax
Plug 'mxw/vim-jsx'
" emmet
Plug 'mattn/emmet-vim'
" markdown previewer
Plug 'shime/vim-livedown'

call plug#end()

" Edit vim-airline
function! AirlineInit()
  call airline#parts#define_raw('shiftwidth', 'sw:%{&shiftwidth}')
  let g:airline_section_y = airline#section#create_right(['ffenc', 'shiftwidth'])
endfunction
autocmd VimEnter * call AirlineInit()
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call SummarizeTabs()
endfunction

function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction

" colorscheme
colorscheme challenger_deep

" make buffers hide automatically instead of needing to be asked
set hidden

" tab stuff
set tabstop=4

" wrap and linebreak
set linebreak
set showbreak=…

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
" have fzf ignore .gitignore files
" NOTE: This requires the_silver_searcher to be installed
" NOTE: Put a '.ignore' file in project folder to filter things out (i.e. node_modules)
" see: https://github.com/ggreer/the_silver_searcher
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -U -l -g ""'

" ignored directories in grep
set wildignore+=node_modules/**,target/**

" bracket matching
let g:rainbow_active = 0

" enable mouse
set mouse=a

" ALE stuff
" Enable completion where available.
let g:ale_fixers = {
      \   'generic': [ 'remove_trailing_lines' ],
      \   'javascript': [ 'eslint' ],
      \}

" let g:ale_completion_enabled = 1
nmap <silent> <Leader>j <Plug>(ale_next_wrap)
nmap <silent> <Leader>k <Plug>(ale_previous_wrap)

" completor stuff
let g:completor_racer_binary = '/Users/Matt/.cargo/bin/racer'
let g:completor_tsserver_binary = '/usr/local/bin/tsserver'

" emmet stuff
let g:user_emmet_settings = {
  \  'javascript.jsx' : {
    \      'extends' : 'jsx',
    \  },
  \}

" spelling
" setlocal spell spelllang=en_us
" NERDTree stuff
let NERDTreeShowHidden=1

" Map leader to space, this should be before any <Leader> mappings
let mapleader=" "

" selected text search mapping
vnoremap // y/\V<C-R>"<CR>

" Rainbow
nnoremap <silent> <Leader>r :RainbowToggle<CR>

" completor mappings
inoremap <expr> <Tab> pumvisible() ? "\<C-n>\<C-y>" : "\<Tab>"

" NERDTree mappings
nnoremap <silent> <Leader>\ :NERDTreeToggle<CR>
nnoremap <silent> <Leader>0 :NERDTreeFind<CR>

" unimpaired bubble mappings
nmap <C-k> [e
nmap <C-j> ]e
vmap <C-k> [egv
vmap <C-j> ]egv

" Fuzzy search commands
nnoremap <Leader>p :Commands<CR>
" Fuzzy search files in project, ignoring .gitignore files
nnoremap <Leader>e :Files<CR>
" Fuzzy search in files
nnoremap <Leader>f :Ag<CR>
vnoremap <Leader>f y:Ag <C-R>"<CR>

" Fuzzy search buffers
nnoremap <Leader>b :Buffers<CR>

"This unsets the "last search pattern" register by hitting return
nnoremap <silent> <Leader>n :noh<CR>

" For the flashy plugin
map y <Plug>(operator-flashy)
nmap Y <Plug>(operator-flashy)$

" location window mappins
nmap <Leader>] :lne<CR>
nmap <Leader>[ :lpr<CR>

" show settings file
nnoremap <silent> <Leader>, :e $MYVIMRC<CR>

" close window
nmap <silent> <Leader>w :bd<CR>

" useful things
" Use this command to write things as sudo: `:w !sudo tee %`
" use `par` for better formatting: `:set formatprg=par`
