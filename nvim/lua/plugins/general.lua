return {
  -- auto close pairs
  {
    'https://github.com/m4xshen/autoclose.nvim',
    opts = {},
  },

  -- Close all buffers but current/specified one
  {
    'https://github.com/schickling/vim-bufonly',
    keys = {
      { '<leader>O', ':Bonly<cr>', desc = 'Close other buffers', silent = true }
    }
  },

  -- edit macros
  'https://github.com/dohsimpson/vim-macroeditor',

  -- sane window removal management
  {
    'https://github.com/mhinz/vim-sayonara',
    events = 'VeryLazy',
    keys = {
      { '<Leader>w,', ':Sayonara!<CR>', silent = true },
      { '<Leader>q',  ':Sayonara<CR>',  silent = true },
    },
  },

  -- css colors
  {
    'brenoprata10/nvim-highlight-colors',
    opts = {},
  },

  -- alignment
  'https://github.com/junegunn/vim-easy-align',
  config = function ()
    vim.cmd([[
      " Start interactive EasyAlign in visual mode (e.g. vipga)
      xmap ga <Plug>(EasyAlign)
      " Start interactive EasyAlign for a motion/text object (e.g. gaip)
      nmap ga <Plug>(EasyAlign)
    ]])
  end,

  -- diff stuff
  {
    'https://github.com/sindrets/diffview.nvim',
    keys = {
      { '<Leader>do', ':DiffviewOpen<CR>' },
      { '<Leader>dh', ':DiffviewFileHistory %<CR>' },
    }
  },

  -- Start screen
  {
    'https://github.com/mhinz/vim-startify',
    config = function()
      vim.g.startify_change_to_dir = 0
    end,
  },


  -- Better matching
  'https://github.com/andymass/vim-matchup',

  -- Whitespace trimmer
  'https://github.com/KorySchneider/vim-trim',

  -- local config safety
  {
    'https://github.com/klen/nvim-config-local',
    opts = {},
  },

  -- helm
  'https://github.com/towolf/vim-helm',

  -- terraform
  'https://github.com/hashivim/vim-terraform',

}
