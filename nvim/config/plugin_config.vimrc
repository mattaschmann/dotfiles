" Use deoplete.
let g:deoplete#enable_at_startup = 1
inoremap <expr><C-y> deoplete#close_popup()
inoremap <expr><CR> pumvisible() ? deoplete#close_popup() : "\<CR>"

" ALE stuff
" Enable completion where available.
let g:ale_fixers = {
      \   'generic': [ 'remove_trailing_lines' ],
      \   'javascript': [ 'eslint' ],
      \}

" NERDTree stuff
let NERDTreeShowHidden=1

" NERDTree mappings
nnoremap <silent> <Leader>\ :NERDTreeToggle<CR>
nnoremap <silent> <Leader>0 :NERDTreeFind<CR>

" unimpaired bubble mappings
nmap <C-K> [e
nmap <C-J> ]e
vmap <C-K> [egv
vmap <C-J> ]egv

" For the flashy plugin
map y <Plug>(operator-flashy)
nmap Y <Plug>(operator-flashy)$

" incsearch plugin mappings
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" Ferret mappings
nmap <leader>z <Plug>(FerretAcks)

" Edit vim-airline
function! AirlineInit()
  call airline#parts#define_raw('shiftwidth', 'sw:%{&shiftwidth}')
  let g:airline_section_y = airline#section#create_right(['ffenc', 'shiftwidth'])
endfunction
autocmd VimEnter * call AirlineInit()
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

