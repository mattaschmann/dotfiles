return {
  -- colorscheme
  'https://github.com/alexmozaidze/palenight.nvim',
  -- lazy = false,
  -- priority = 1000,
  config = function()
    vim.opt.background = 'dark'
    vim.cmd.colorscheme 'palenight'
    -- vim.cmd([[
    --   syntax enable
    --   colorscheme palenight
    --   let g:palenight_terminal_italics=1
    --   hi DiffAdd      gui=none guifg=NONE    guibg=#2e4730
    --   hi DiffChange   gui=none guifg=NONE    guibg=#47452e
    --   hi DiffDelete   gui=bold guifg=#a02e2e guibg=#472e2e
    --   hi DiffText     gui=none guifg=NONE    guibg=#2e4047
    --   hi Search       gui=none guifg=#262626 guibg=#77839e
    --   hi HighlightedyankRegion ctermbg=237 guibg=#404040
    -- ]])
  end,
}

