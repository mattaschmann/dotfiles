return {
  'https://github.com/nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    local configs = require('nvim-treesitter.configs')

    configs.setup({
      ensure_installed = {
        'lua',
        'vim',
        'vimdoc',
        'bash',
        'markdown',
        'markdown_inline',
        'javascript',
        'typescript',
        'python',
        'yaml',
        'regex',
      },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}
