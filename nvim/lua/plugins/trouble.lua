-- diagnostic window
return {
  'https://github.com/folke/trouble.nvim',
  event = 'VeryLazy',
  opts = {},
  keys = {
    { '<f9>', '<cmd>Trouble diagnostics toggle<cr>' },
  },
  -- @Matt TODO: setup keymaps
}
