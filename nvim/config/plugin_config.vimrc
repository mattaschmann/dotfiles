" Use deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#ignore_case = 1
let g:deoplete#file#enable_buffer_path = 1
inoremap <expr><C-y> deoplete#close_popup()
inoremap <expr><CR> pumvisible() ? "\<C-n>\<C-y>" : "\<CR>"

" neosnippets config
let g:neosnippet#snippets_directory = "~/.dotfiles/nvim/neosnippets"
imap <expr><TAB>
  \ neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)" :
  \ pumvisible() ? "\<C-n>" : "\<TAB>"

" ALE stuff
" Enable completion where available.
nnoremap <silent> <Leader>. :ALEFix<CR>
nnoremap <silent> <F8> :ALENextWrap<CR>
nnoremap <silent> <S-F8> :ALEPreviousWrap<CR>
let g:ale_linters = {
      \   'rust': [ 'rls' ]
      \}
let g:ale_fixers = {
      \   'css': [ 'trim_whitespace' ],
      \   'html': [ 'trim_whitespace' ],
      \   'javascript': [ 'eslint', 'trim_whitespace' ],
      \   'json': [ 'jq', 'trim_whitespace' ],
      \   'markdown': ['prettier', 'trim_whitespace', 'remove_trailing_lines' ],
      \   'python': ['trim_whitespace' ],
      \   'scss': [ 'trim_whitespace' ],
      \   'typescript': [ 'tslint', 'trim_whitespace' ],
      \   'vim': [ 'remove_trailing_lines', 'trim_whitespace' ],
      \   'yaml': [ 'trim_whitespace' ],
      \}
let g:ale_sign_error = '->'
let g:ale_rust_rls_toolchain = 'stable'

" NERDTree stuff
let g:NERDTreeShowHidden=1
let g:NERDTreeWinSize=60
" NERDTree mappings
nnoremap <silent> <Leader>\ :NERDTreeToggle<CR>
nnoremap <silent> <Leader>0 :NERDTreeFind<CR>

" " unimpaired bubble mappings
nmap <A-k> [e
nmap <A-j> ]e
vmap <A-k> [egv
vmap <A-j> ]egv

" incsearch plugin mappings
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" Ferret mappings
nmap <Leader>a <Plug>(FerretAck)
nmap <LocalLeader>a <Plug>(FerretAcks)

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
let g:user_emmet_leader_key = '<A-y>'
function! CustomEmmetInit()
  :EmmetInstall
  imap <C-e> <Plug>(emmet-expand-abbr)
endfunction
autocmd FileType html,css,jsx,javascript,javascript.jsx call CustomEmmetInit()

" Goyo/Limelight (prose) stuff
nnoremap <silent> <LocalLeader>g :Goyo<CR>
autocmd! User GoyoEnter Limelight | ALEDisableBuffer | let g:deoplete#disable_auto_complete = 1
autocmd! User GoyoLeave Limelight! | ALEEnableBuffer | let g:deoplete#disable_auto_complete = 0

" git gutter
nmap <LocalLeader>hp <Plug>GitGutterPreviewHunk
nmap <LocalLeader>hs <Plug>GitGutterStageHunk
nmap <LocalLeader>hu <Plug>GitGutterUndoHunk
autocmd BufEnter,FocusGained * GitGutter " reload gitgutter on focus

" Fugitive stuff
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gc :Gcommit
nnoremap <Leader>gp :Gpush<CR>

" vim highlightedyank stuff
let g:highlightedyank_highlight_duration = 150
let g:highlightedyank_max_lines = 1000
highlight HighlightedyankRegion ctermbg=237 guibg=#404040

" match tag jump for html
nnoremap <leader>% :MtaJumpToOtherTag<CR>

" Sayonara mappins
" delete current buffer and either keep or close pane
nnoremap <silent> <Leader>w :Sayonara!<CR>
nnoremap <silent> <Leader>q :Sayonara<CR>

" nvim_typescript stuff
let g:nvim_typescript#signature_complete = 1

" easyalign
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" jsx stuff
let g:jsx_ext_required = 1
