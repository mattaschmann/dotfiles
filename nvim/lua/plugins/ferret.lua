-- for better searching
return {
  'https://github.com/wincent/ferret',
  lazy = false,
  keys = {
    {'<Leader>a', '<Plug>(FerretAck)', desc = 'Search with ferret'},
    {'<Leader>a', 'y:Ack <C-R>0', mode = 'v', desc = 'Search selection with ferret'},
    {'<LocalLeader>a', '<Plug>(FerretAcks)', desc = 'Acks with ferret'},
  },
  config = function()
    vim.g.FerretExecutable = 'rg'
    vim.g.FerretExecutableArguments = {
      {rg = '--vimgrep --no-heading --no-config --max-columns 4096 --hidden'}
    }

--     vim.keymap.set('n', '<leader>m', '<cmd>Ack -. @Matt<cr>')
  end
}
