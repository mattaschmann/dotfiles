" Map leader to space, this should be before any <Leader> mappings
let mapleader=" "

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
Plug '/usr/local/opt/fzf'
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
" typescript syntax
Plug 'leafgarland/typescript-vim'
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
" Undo branching visualization
Plug 'simnalamburt/vim-mundo'
" Better search highlighting
Plug 'haya14busa/incsearch.vim'
" Better project searching
Plug 'wincent/ferret'
" Task plugin
Plug 'irrationalistic/vim-tasks'
" Completions
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" rust
Plug 'racer-rust/vim-racer'

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

" NOTE: This requires ripgrep to be installed
" NOTE: Put a '.ignore' file in project folder to filter things out (i.e. node_modules)

" Copied from fzf-vim help files
" Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --ignore-case --no-ignore-vcs --hidden '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" Likewise, Files command with preview window
" Customized from helpfile to get the '?' functionality
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

    " Mapping selecting mappings
    nmap <leader><tab> <plug>(fzf-maps-n)
    xmap <leader><tab> <plug>(fzf-maps-x)
    omap <leader><tab> <plug>(fzf-maps-o)

    " Insert mode completion
    imap <c-x><c-k> <plug>(fzf-complete-word)
    imap <c-x><c-f> <plug>(fzf-complete-path)
    imap <c-x><c-j> <plug>(fzf-complete-file-ag)
    imap <c-x><c-l> <plug>(fzf-complete-line)

    " Advanced customization using autoload functions
    inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})

" ignored directories in grep
set wildignore+=node_modules/**,target/**

" bracket matching
let g:rainbow_active = 0

" enable mouse
set mouse=a

" Use deoplete.
let g:deoplete#enable_at_startup = 1

" disable python2
let g:loaded_python_provider = 1

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
nnoremap <Leader>f :Rg<Space>
vnoremap <Leader>f y:Rg <C-R>"<CR>
" Fuzzy search in current file
nnoremap <Leader>l :Lines<CR>

" Fuzzy search buffers
nnoremap <Leader>b :Buffers<CR>

"This unsets the "last search pattern" register by hitting return
nnoremap <silent> <Leader>n :noh<CR>

" For the flashy plugin
map y <Plug>(operator-flashy)
nmap Y <Plug>(operator-flashy)$

" show settings file
nnoremap <silent> <Leader>, :e $MYVIMRC<CR>

" close window
nmap <silent> <Leader>w :bd<CR>

" incsearch plugin mappings
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" useful things
" Use this command to write things as sudo: `:w !sudo tee %`
" use `par` for better formatting: `:set formatprg=par`

