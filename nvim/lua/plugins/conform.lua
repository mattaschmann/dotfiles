return {
  'https://github.com/stevearc/conform.nvim',
  config = function()
    local conform = require('conform')

    conform.setup({
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' },
      },
    })

    vim.api.nvim_create_user_command('Format', function()
      conform.format()
    end, { desc = 'Run conform on current buffer' })
  end,
}
