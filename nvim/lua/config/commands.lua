-- Run format on current buffer
vim.api.nvim_create_user_command('Format', function() vim.lsp.buf.format() end, {desc='Run lsp format on current buffer'})
