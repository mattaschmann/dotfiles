return {
  'https://github.com/junegunn/goyo.vim',
  config = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'GoyoEnter',
      callback = function()
        require('lualine').hide()
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'GoyoLeave',
      callback = function()
        require('lualine').hide({ unhide = true })
      end,
    })
  end,
}
