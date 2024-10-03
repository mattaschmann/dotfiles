return {
  -- {
  --   'https://github.com/alexmozaidze/palenight.nvim',
  --   opts = {
  --     italic = true,
  --   },
  --   config = function()
  --     vim.opt.background = 'dark'
  --     vim.cmd.colorscheme 'palenight'
  --     vim.cmd([[
  --       hi DiffAdd      gui=none guifg=NONE    guibg=#2e4730
  --       hi DiffChange   gui=none guifg=NONE    guibg=#47452e
  --       hi DiffDelete   gui=bold guifg=#a02e2e guibg=#472e2e
  --       hi DiffText     gui=none guifg=NONE    guibg=#2e4047
  --     ]])
  --   end,
  -- },
  {
    'https://github.com/catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function ()
      require('catppuccin').setup({
        flavour = 'macchiato', -- latte, frappe, macchiato, mocha
      })
      vim.opt.background = 'dark'
      vim.cmd.colorscheme 'catppuccin'

      vim.cmd([[
        hi MsgArea gui=none guifg=NONE    guibg=#22232B
        hi SpellBad cterm=undercurl gui=undercurl ctermfg=204 guifg=#ff5370
      ]])
    end
  }
}
