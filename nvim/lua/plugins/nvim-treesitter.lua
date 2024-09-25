return {
  'https://github.com/nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    local configs = require('nvim-treesitter.configs')

    configs.setup({
      ensure_installed = {
        'bash',
        'javascript',
        'json',
        'lua',
        'markdown',
        'markdown_inline',
        'python',
        'regex',
        'toml',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
      },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
