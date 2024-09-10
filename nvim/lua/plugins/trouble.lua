-- diagnostic window
return {
  'https://github.com/folke/trouble.nvim',
  event = 'VeryLazy',
  opts = {},
  keys = {
    { '<f7>', '<cmd>Trouble diagnostics<cr>' },
  },
  -- @Matt TODO: setup keymaps
}
