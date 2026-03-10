return {
  'https://github.com/kylechui/nvim-surround',
  event = 'VeryLazy',
  config = function()
    vim.keymap.set({ 'v' }, 'gs', '<Plug>(nvim-surround-visual)')
  end
}
