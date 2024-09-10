-- This unsets the "last search pattern" register
vim.keymap.set('n', '<leader>n', '<cmd>noh<cr>', { silent = true })

-- Open current file in yazi in a tmux split
vim.keymap.set('n', '<localleader>y', '<cmd>!tmux split-window "yazi %"<cr><cr>', { silent = true })

-- save file
vim.keymap.set('n', '<leader>s', '<cmd>update<cr>', { silent = true })

-- toggle relative numbers
vim.keymap.set('n', '<localleader>r', '<cmd>set relativenumber!<cr>', { silent = true })

-- Add a map to more easily open the command history
vim.keymap.set({ 'n', 'v' }, '<leader>;', 'q:')

-- diagnostic navigation
vim.keymap.set('n', '<f8>', function() vim.diagnostic.goto_next() end)
vim.keymap.set('n', '<f7>', function() vim.diagnostic.goto_prev() end)

-- lsp
vim.keymap.set('n', 'gs', function() vim.lsp.buf.hover() end)
vim.keymap.set('n', 'gh', function() vim.lsp.buf.signature_help() end)
vim.keymap.set('n', 'gf', '<cmd>Format<cr>', { desc = 'Format current buffer' })

vim.cmd([[

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
imap <C-U> <Esc>

" Make Y yank till end of line
nnoremap Y y$

" Copy current @0 register to @+ for use in system clipboard
nnoremap <Leader>c :let @+ = @0<CR>

" Shortcut to highlight block
nnoremap gb V$%

" Shortcut for opening file in vscode
nnoremap <LocalLeader>c :Code<CR>

" Shortcut for opening file in intellij
nnoremap <LocalLeader>i :Idea<CR>

" diff shortcut
nnoremap <LocalLeader>dt :windo diffthis<CR>
nnoremap <LocalLeader>du :diffupdate<CR>
nnoremap <LocalLeader>D :bufdo diffoff<CR>

" Shortcut for :only
nnoremap <Leader>o :only<CR>

]])
