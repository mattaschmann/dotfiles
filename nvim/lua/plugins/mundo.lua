return {
  -- Undo branching visualization
  'https://github.com/simnalamburt/vim-mundo',
  config = function()
    vim.keymap.set('n', '<f5>', '<cmd>MundoToggle<cr>')
    vim.cmd([[
      set undofile
      set undodir=~/.config/nvim/undo
    ]])
  end
}
