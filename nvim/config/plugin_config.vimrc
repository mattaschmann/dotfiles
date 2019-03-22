" Use deoplete
" let g:deoplete#enable_at_startup = 1
" let g:deoplete#ignore_case = 1
" let g:deoplete#file#enable_buffer_path = 1
" call deoplete#custom#source('tabnine', 'rank', 101)
" inoremap <expr><C-y> deoplete#close_popup()
" inoremap <expr><CR> pumvisible() ? "\<C-n>\<C-y>" : "\<CR>"

" neosnippets config
let g:neosnippet#snippets_directory = "~/.dotfiles/nvim/neosnippets"
imap <expr><TAB>
      \ neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)" :
      \ pumvisible() ? "\<C-n>" : "\<TAB>"

" Edit vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" ALE stuff
" Enable completion where available.
" nnoremap <silent> <Leader>. :ALEFix<CR>
" nnoremap <silent> <F8> :ALENextWrap<CR>
" nnoremap <silent> <S-F8> :ALEPreviousWrap<CR>
" let g:ale_linters = {
"       \   'javascript': [ 'eslint' ],
"       \   'typescript': [ 'tslint' ],
"       \   'rust': [ 'cargo' ],
"       \}
" let g:ale_fixers = {
"       \   'css': [ 'trim_whitespace' ],
"       \   'graphql': [ 'prettier', 'trim_whitespace' ],
"       \   'html': [ 'trim_whitespace' ],
"       \   'javascript': [ 'eslint', 'trim_whitespace' ],
"       \   'json': [ 'jq', 'trim_whitespace' ],
"       \   'markdown': ['prettier', 'trim_whitespace', 'remove_trailing_lines' ],
"       \   'python': ['trim_whitespace' ],
"       \   'rust': [ 'rustfmt', 'trim_whitespace' ],
"       \   'scss': [ 'trim_whitespace' ],
"       \   'typescript': [ 'tslint', 'trim_whitespace' ],
"       \   'vim': [ 'remove_trailing_lines', 'trim_whitespace' ],
"       \   'yaml': [ 'trim_whitespace' ],
"       \}
" let g:ale_sign_error = '->'
" let g:ale_rust_rls_toolchain = 'stable'

" nvim-typescript stuff
" au FileType typescript nnoremap <F5> :TSGetCodeFix<CR>

" unimpaired bubble mappings
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
" TODO: disable coc?
" autocmd! User GoyoEnter Limelight | ALEDisableBuffer | let g:deoplete#disable_auto_complete = 1
" autocmd! User GoyoLeave Limelight! | ALEEnableBuffer | let g:deoplete#disable_auto_complete = 0

" git gutter
nmap <LocalLeader>hp <Plug>GitGutterPreviewHunk
nmap <LocalLeader>hs <Plug>GitGutterStageHunk
nmap <LocalLeader>hu <Plug>GitGutterUndoHunk
autocmd BufEnter,FocusGained * GitGutter " reload gitgutter on focus

" Fugitive stuff
nnoremap <Leader>gs :Gstatus<CR>

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

" easyalign
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" dirvish settings
let g:dirvish_mode = ':sort ,^.*[\/],'

" Autoformat stuff (used mostly for html)
nnoremap <LocalLeader>b :Autoformat<CR>

" DirDiff
let g:DirDiffExcludes = "node_modules,.git"

" Gutentags
au FileType gitcommit,gitrebase let g:gutentags_enabled=0

" CoC
" Use <c-space> to trigger completion
inoremap <silent><expr> <C-Space> coc#refresh()
" use enter for completion
inoremap <expr><CR> pumvisible() ? "\<C-n>\<C-y>" : "\<CR>"
nmap <silent> <F8> <Plug>(coc-diagnostic-next)
nmap <silent> <S-F8> <Plug>(coc-diagnostic-prev)
nmap <silent> <Leader>. <Plug>(coc-codeaction)
nnoremap <silent> <F2> :CocCommand<CR>
nnoremap <silent> <F1> :CocList<CR>
nnoremap <silent> <F7> :CocList diagnostics<CR>
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'
" color config for coc
highlight CocErrorHighlight guifg=#ff0000
highlight CocWarningHighlight guifg=#ff922b
highlight CocInfoHighlight guifg=#95ffa4
highlight CocInfoSign guifg=#95ffa4
highlight CocHintHighlight guifg=#15aabf
highlight CocHighlightText gui=underline
" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')
" Use `:Format` for format current buffer
command! -nargs=0 Format :call CocAction('format')

" Mundo (undo tree)
nnoremap <F5> :MundoToggle<CR>
