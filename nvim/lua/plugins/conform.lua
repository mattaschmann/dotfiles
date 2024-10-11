return {
  'https://github.com/stevearc/conform.nvim',
  config = function()
    local conform = require('conform')

    conform.setup({
      default_format_opts = {
        lsp_format = 'fallback',
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },
        toml = { 'taplo' },
        json = { 'fixjson' },
        markdown = { 'prettier' },
        yaml = { 'prettier' },
        typescript = { 'prettier' },
        javascript = { 'prettier' },
      },
    })

    vim.api.nvim_create_user_command('Format', function()
      conform.format()
    end, { desc = 'Run conform on current buffer' })
  end,
}
