return {
  'https://github.com/pmizio/typescript-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  opts = {
    on_attach = function ()
       vim.keymap.set('n', 'gd', '<cmd>TSToolsGoToSourceDefinition<cr>')
    end,
  },
}
