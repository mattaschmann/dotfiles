"This unsets the "last search pattern" register
nnoremap <silent> <Leader>n :noh<CR>

" reload settings file
nnoremap <silent> <LocalLeader>r :so $MYVIMRC<CR>

" quit out of insert mode in an easier way
inoremap jj <Esc>

" save file
nnoremap <silent> <Leader>s :update<CR>

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
nnoremap <Leader>L :call MoveBufferRightSplit()<CR>
nnoremap <Leader>H :call MoveBufferLeftSplit()<CR>
nnoremap <Leader>J :call MoveBufferBottomSplit()<CR>
nnoremap <Leader>K :call MoveBufferTopSplit()<CR>

" Make current word uppercase in insert mode, since I have caps lock remapped
" to ctrl
imap <C-U> <Esc>mzgUiw`za

" Make Y yank till end of line
nnoremap Y y$

" Copy current @0 register to @+ for use in system clipboard
nnoremap <Leader>c :let @+ = @0<CR>

" Add a map to more easily open the command history
nnoremap <Leader>; q:

" Remap alternate file
nnoremap <Leader>` <C-^>

" Shortcut to highlight block
nnoremap gb V$%

" Shortcut for opening file in vscode
nnoremap <LocalLeader>c :Code<CR>

" diff shortcut
nnoremap <LocalLeader>dt :windo diffthis<CR>
nnoremap <LocalLeader>du :diffupdate<CR>
nnoremap <LocalLeader>D :bufdo diffoff<CR>

