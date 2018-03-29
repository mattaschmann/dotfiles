" Use deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
inoremap <expr><C-y> deoplete#close_popup()
inoremap <expr><CR> pumvisible() ? "\<C-n>" : "\<CR>"

" neosnippets config
let g:neosnippet#snippets_directory = "~/.dotfiles/nvim/neosnippets"
imap <expr><TAB>
  \ neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)" :
  \ pumvisible() ? "\<C-n>" : "\<TAB>"

" ALE stuff
" Enable completion where available.
nnoremap <silent> <LocalLeader>f :ALEFix<CR>
nnoremap <silent> <Leader>j :ALENextWrap<CR>
nnoremap <silent> <Leader>k :ALEPreviousWrap<CR>
" let g:ale_linters = {
"       \   'text': [ 'vale', 'proselint', 'write good' ]
"       \}
let g:ale_fixers = {
      \   'javascript': [ 'eslint', 'trim_whitespace' ],
      \   'markdown': ['prettier', 'trim_whitespace', 'remove_trailing_lines' ],
      \   'vim': [ 'remove_trailing_lines', 'trim_whitespace' ],
      \}

" NERDTree stuff
let NERDTreeShowHidden=1

" NERDTree mappings
nnoremap <silent> <Leader>\ :NERDTreeToggle<CR>
nnoremap <silent> <Leader>0 :NERDTreeFind<CR>

" " unimpaired bubble mappings
" nmap <Leader>k [e
" nmap <Leader>j ]e
" vmap <Leader>k [egv
" vmap <Leader>j ]egv

" For the flashy plugin
map y <Plug>(operator-flashy)
nmap Y <Plug>(operator-flashy)$

" incsearch plugin mappings
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" Ferret mappings
nmap <LocalLeader>a <Plug>(FerretAck)
nmap <LocalLeader>r <Plug>(FerretAcks)

" Edit vim-airline
function! AirlineInit()
  call airline#parts#define_raw('shiftwidth', 'sw:%{&shiftwidth}')
  let g:airline_section_y = airline#section#create_right(['ffenc', 'shiftwidth'])
endfunction
autocmd VimEnter * call AirlineInit()
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" Emmet stuff
let g:user_emmet_install_global = 0
autocmd FileType html,css,jsx,javascript,javascript.jsx EmmetInstall | map <LocalLeader>e <Plug>(emmet-expand-abbr)

" Goyo/Limelight (prose) stuff
nnoremap <silent> <LocalLeader>g :Goyo<CR>
autocmd! User GoyoEnter Limelight | ALEDisableBuffer | let g:deoplete#disable_auto_complete = 1
autocmd! User GoyoLeave Limelight! | ALEEnableBuffer | let g:deoplete#disable_auto_complete = 0

" git gutter maps
nmap <LocalLeader>hp <Plug>GitGutterPreviewHunk
nmap <LocalLeader>hs <Plug>GitGutterStageHunk
nmap <LocalLeader>hu <Plug>GitGutterUndoHunk

