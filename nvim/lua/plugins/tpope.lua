return {
  -- git integration
  {
    'https://github.com/tpope/vim-fugitive',
    keys = {
      {'<Leader>gs', '<cmd>Git<CR>', desc = 'Open git commit window'},
      {'<Leader>gp', ':Git push<CR>', desc = 'Git push'},
    },
  },

  -- smart set shiftwidth
  {'https://github.com/tpope/vim-sleuth'},

  -- make changing surrounds easier
  {'https://github.com/tpope/vim-surround'},

  -- make comments easier
  {'https://github.com/tpope/vim-commentary'},

  -- use repeat with plugins
  {'https://github.com/tpope/vim-repeat'},

  -- some nice keyboard mappings (including bubbling)
  {'https://github.com/tpope/vim-unimpaired'},

  -- directory stuff by tpope
  {'https://github.com/tpope/vim-eunuch'},

  -- smart substitute by tpope
  {'https://github.com/tpope/vim-abolish'},

  -- tpope's async stuff
  {'https://github.com/tpope/vim-dispatch'},
}
