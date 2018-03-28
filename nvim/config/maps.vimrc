"This unsets the "last search pattern" register
nnoremap <silent> <Leader>n :noh<CR>

" show settings file
nnoremap <silent> <Leader>, :e $MYVIMRC<CR>
" reload settings file
nnoremap <silent> <LocalLeader>r :so $MYVIMRC<CR>

" quit out of insert mode in an easier way
inoremap jj <Esc>

" close window
nnoremap <silent> <Leader>w :bdelete<CR>

" save file
nnoremap <silent> <Leader>s :update<CR>

" save and exit
nnoremap <Leader>x :xit<CR>

" quit
nnoremap <Leader>q :quit<CR>

" toggle relative numbers
nnoremap <silent> <Leader>r :set relativenumber!<CR>

" easier window movement
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" spell toggle
nnoremap <silent> <LocalLeader>s :set spell!<CR>

" Open up a split and switch to next previous buffer
" @Matt TODO: How to preserve the split setting?
nnoremap <Leader>L :set nosplitright<CR>:vsp +bp<CR><C-W>l
nnoremap <Leader>H :set splitright<CR>:vsp +bp<CR><C-W>h
