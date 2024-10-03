  -- diff stuff
  return {
    'https://github.com/sindrets/diffview.nvim',
    event = 'VeryLazy',
    keys = {
      { '<Leader>do', ':DiffviewOpen<CR>' },
      { '<Leader>dh', ':DiffviewFileHistory %<CR>' },
    }
  }

