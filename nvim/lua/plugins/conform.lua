return {
  'https://github.com/stevearc/conform.nvim',
  config = function()
    local conform = require('conform')

    conform.setup({
      default_format_opts = {
        lsp_format = 'fallback',
      },
      formatters_by_ft = {
        javascript = { 'prettier' },
        json = { 'fixjson' },
        lua = { 'stylua' },
        markdown = { 'prettier' },
        python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },
        toml = { 'taplo' },
        typescript = { 'prettier' },
        yaml = { 'prettier' },
      },
    })

    vim.api.nvim_create_user_command('Format', function()
      conform.format()
    end, { desc = 'Run conform on current buffer' })
  end,
}
