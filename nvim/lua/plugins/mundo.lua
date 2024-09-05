return {
  -- Undo branching visualization
  'https://github.com/simnalamburt/vim-mundo',
  keys = {
    {'<f5>', '<cmd>MundoToggle<cr>'}
  },
  config = function()
    vim.cmd([[
      set undofile
      set undodir=~/.config/nvim/undo
    ]])
  end
}
