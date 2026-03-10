return {
  'https://github.com/kylechui/nvim-surround',
  version = '*', -- Use for stability; omit to use `main` branch for the latest features
  event = 'VeryLazy',
  config = function()
    vim.keymap.set({ 'v' }, 'gs', '<Plug>(nvim-surround-visual)')
  end
}
