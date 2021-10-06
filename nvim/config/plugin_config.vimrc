" neosnippets config
let g:neosnippet#snippets_directory = "~/.dotfiles/nvim/neosnippets"
imap <expr><TAB>
      \ neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)" :
      \ pumvisible() ? "\<C-n>" : "\<TAB>"

" Edit vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" unimpaired bubble mappings
nmap <A-k> [e
nmap <A-j> ]e
vmap <A-k> [egv
vmap <A-j> ]egv

" incsearch plugin mappings
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" Ferret
let g:FerretExecutableArguments = {
      \   'rg': '--vimgrep --no-heading --no-config --max-columns 4096 --hidden'
      \ }
nmap <Leader>a <Plug>(FerretAck)
vmap <Leader>a y:Ack <C-R>"
nmap <LocalLeader>a <Plug>(FerretAcks)

" Emmet stuff
let g:user_emmet_install_global = 0
let g:user_emmet_leader_key = '<A-y>'
function! CustomEmmetInit()
  :EmmetInstall
  imap <C-e> <Plug>(emmet-expand-abbr)
endfunction
autocmd FileType html,css,jsx,javascript,javascript.jsx call CustomEmmetInit()

" git gutter
nmap <LocalLeader>hp <Plug>(GitGutterPreviewHunk)
nmap <LocalLeader>hs <Plug>(GitGutterStageHunk)
nmap <LocalLeader>hu <Plug>(GitGutterUndoHunk)
autocmd BufEnter,FocusGained * GitGutter " reload gitgutter on focus

" Fugitive stuff
nnoremap <Leader>gs :Git<CR>
nnoremap <Leader>gp :Git push<CR>

" vim highlightedyank stuff
let g:highlightedyank_highlight_duration = 150
let g:highlightedyank_max_lines = 1000
highlight HighlightedyankRegion ctermbg=237 guibg=#404040

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
" let g:dirvish_mode = ':sort ,^.*[\/],'

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
nmap <silent> <Leader>. <Plug>(coc-codeaction-line)
vmap <silent> <Leader>. <Plug>(coc-codeaction-selected)
nnoremap <silent> <F2> :CocCommand<CR>
nnoremap <silent> <F1> :CocList<CR>
nnoremap <silent> <F7> :CocList diagnostics<CR>
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> gh :call CocAction('doHover')<CR>
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

" which key
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :WhichKey '\'<CR>

" nvim-tree
lua << EOF
require'nvim-tree'.setup {
  disable_netrw = false,
  hijack_netrw = false,
}
EOF
nnoremap - :NvimTreeFindFile<CR>
nnoremap <LocalLeader>f :NvimTreeToggle<CR>

" nvim-web-icons
lua << EOF
require'nvim-web-devicons'.setup()
EOF
