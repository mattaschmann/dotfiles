" Use deoplete.
let g:deoplete#enable_at_startup = 1

" ALE stuff
" Enable completion where available.
let g:ale_fixers = {
      \   'generic': [ 'remove_trailing_lines' ],
      \   'javascript': [ 'eslint' ],
      \}

nmap <silent> <Leader>j <Plug>(ale_next_wrap)
nmap <silent> <Leader>k <Plug>(ale_previous_wrap)

" NERDTree stuff
let NERDTreeShowHidden=1

" NERDTree mappings
nnoremap <silent> <Leader>\ :NERDTreeToggle<CR>
nnoremap <silent> <Leader>0 :NERDTreeFind<CR>

" unimpaired bubble mappings
nmap <C-k> [e
nmap <C-j> ]e
vmap <C-k> [egv
vmap <C-j> ]egv

" For the flashy plugin
map y <Plug>(operator-flashy)
nmap Y <Plug>(operator-flashy)$

" incsearch plugin mappings
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

