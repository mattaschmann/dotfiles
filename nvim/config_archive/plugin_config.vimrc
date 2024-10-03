" Edit vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" " unimpaired bubble mappings
" nmap <A-k> [e
" nmap <A-j> ]e
" vmap <A-k> [egv
" vmap <A-j> ]egv

" " incsearch plugin mappings
" map /  <Plug>(incsearch-forward)
" map ?  <Plug>(incsearch-backward)
" map g/ <Plug>(incsearch-stay)

" Ferret
let g:FerretExecutableArguments = {
      \   'rg': '--vimgrep --no-heading --no-config --max-columns 4096 --hidden'
      \ }
nmap <Leader>a <Plug>(FerretAck)
vmap <Leader>a y:Ack <C-R>"
nmap <LocalLeader>a <Plug>(FerretAcks)

" " git gutter
" nmap <LocalLeader>hp <Plug>(GitGutterPreviewHunk)
" nmap <LocalLeader>hs <Plug>(GitGutterStageHunk)
" nmap <LocalLeader>hu <Plug>(GitGutterUndoHunk)
" autocmd BufEnter,FocusGained * GitGutter " reload gitgutter on focus
" let g:gitgutter_preview_win_floating = 0

" " Fugitive stuff
" nnoremap <Leader>gs :Git<CR>
" nnoremap <Leader>gp :Git push<CR>

" " vim highlightedyank stuff
" let g:highlightedyank_highlight_duration = 150
" let g:highlightedyank_max_lines = 1000
" highlight HighlightedyankRegion ctermbg=237 guibg=#404040

" " Sayonara mappins
" " delete current buffer and either keep or close pane
" nnoremap <silent> <Leader>w :Sayonara!<CR>
" nnoremap <silent> <Leader>q :Sayonara<CR>

" " easyalign
" " Start interactive EasyAlign in visual mode (e.g. vipga)
" xmap ga <Plug>(EasyAlign)
" " Start interactive EasyAlign for a motion/text object (e.g. gaip)
" nmap ga <Plug>(EasyAlign)

" dirvish settings
" let g:dirvish_mode = ':sort ,^.*[\/],'

" Autoformat stuff (used mostly for html)
nnoremap <LocalLeader>b :Autoformat<CR>

" DirDiff
let g:DirDiffExcludes = "node_modules,.git"

" Gutentags
au FileType gitcommit,gitrebase let g:gutentags_enabled=0

"================================================================================
" CoC
"================================================================================

" function! CheckBackspace() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
" inoremap <silent><expr> <TAB>
"       \ coc#pum#visible() ? coc#pum#next(1):
"       \ CheckBackspace() ? "\<Tab>" :
"       \ coc#refresh()

" inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
" inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
"       \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use <c-space> to trigger completion.
" if has('nvim')
"   inoremap <silent><expr> <c-space> coc#refresh()
" else
"   inoremap <silent><expr> <c-@> coc#refresh()
" endif

" nmap <silent> <F8> <Plug>(coc-diagnostic-next)
" nmap <silent> <S-F8> <Plug>(coc-diagnostic-prev)
" nmap <silent> <Leader>. <Plug>(coc-codeaction-line)
" vmap <silent> <Leader>. <Plug>(coc-codeaction-selected)
" nnoremap <silent> <F2> :CocCommand<CR>
" nnoremap <silent> <F1> :CocList<CR>
" nnoremap <silent> <F7> :CocList diagnostics<CR>

" " Remap keys for gotos
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)

" mapping for trouble.nvim
" nmap <silent> gL <cmd>call coc#rpc#request('fillDiagnostics', [bufnr('%')])<CR><cmd>Trouble loclist<CR>`

" " docs stuff
" function! ShowDocumentation()
"   if CocAction('hasProvider', 'hover')
"     call CocActionAsync('doHover')
"   else
"     call feedkeys('K', 'in')
"   endif
" endfunction
" nnoremap <silent> gh :call ShowDocumentation()<CR>

" Highlight symbol under cursor on CursorHold
" autocmd CursorHold * silent call CocActionAsync('highlight')

" " color config for coc
" highlight CocErrorHighlight guifg=#ff0000
" highlight CocWarningHighlight guifg=#ff922b
" highlight CocInfoHighlight guifg=#95ffa4
" highlight CocInfoSign guifg=#95ffa4
" highlight CocHintHighlight guifg=#15aabf
" highlight CocHighlightText gui=underline
" " Use `:Format` for format current buffer
" command! -nargs=0 Format :call CocAction('format')

" Mundo (undo tree)
nnoremap <F5> :MundoToggle<CR>

" startify
let g:startify_change_to_dir = 0
let g:startify_lists = [
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'files',     'header': ['   MRU']            },
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]

" matchup configs
let g:matchup_matchparen_status_offscreen = 0

" Remove all other buffers (BufOnly)
nnoremap <Leader>O :Bonly<CR>

" todo.txt configs
au BufNewFile,BufRead *.todo.txt set filetype=todo
au filetype todo setlocal omnifunc=todo#Complete
let g:TodoTxtUseAbbrevInsertMode=1

" nvim-tree
nnoremap - :NvimTreeFindFile<CR>
nnoremap <LocalLeader>f :NvimTreeToggle<CR>

" doge
let g:doge_doc_standard_python = 'google'

" " vim-test
" nmap <silent> <LocalLeader>t :TestNearest<CR>
" let test#python#runner = 'pytest'
" let test#strategy = "vimux"

" lightspeed
" map <Leader>j <Plug>Lightspeed_s
" map <Leader>k <Plug>Lightspeed_S
" map <Leader><space>j <Plug>Lightspeed_gs
" map <Leader><space>k <Plug>Lightspeed_Gs

" diffview
nmap <Leader>do :DiffviewOpen<CR>
nmap <Leader>dh :DiffviewFileHistory %<CR>