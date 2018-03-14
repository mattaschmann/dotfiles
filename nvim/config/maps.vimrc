" selected text search mapping
vnoremap // y/\V<C-R>"<CR>

"This unsets the "last search pattern" register by hitting return
nnoremap <silent> <Leader>n :noh<CR>

" show settings file
nnoremap <silent> <Leader>, :e $MYVIMRC<CR>
" reload settings file
nnoremap <silent> <Leader>rr :so $MYVIMRC<CR>

" quit out of insert mode in an easier way
inoremap jj <Esc>

" close window
nmap <silent> <Leader>w :bd<CR>

" useful things
" Use this command to write things as sudo: `:w !sudo tee %`
" use `par` for better formatting: `:set formatprg=par`

