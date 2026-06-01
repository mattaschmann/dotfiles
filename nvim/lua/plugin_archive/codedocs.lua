return {
  'https://github.com/jeangiraldoo/codedocs.nvim',
  config = function()
    vim.keymap.set('n', '<localleader>d', require('codedocs').insert_docs)
  end
}
