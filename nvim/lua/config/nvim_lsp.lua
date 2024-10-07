vim.diagnostic.config({
  virtual_text = false,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚',
      [vim.diagnostic.severity.WARN] = '󰀪',
      [vim.diagnostic.severity.INFO] = '󰋽',
      [vim.diagnostic.severity.HINT] = '󰌶',
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
      [vim.diagnostic.severity.WARN] = 'WarningMsg',
    },
    -- numhl = {
    --   [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
    --   [vim.diagnostic.severity.WARN]  = 'WarningMsg',
    --   [vim.diagnostic.severity.INFO]  = 'DiagnosticInfo',
    --   [vim.diagnostic.severity.HINT]  = 'DiagnosticHint',
    -- },
  },
})

-- maps
vim.keymap.set('n', 'gh', function()
  vim.lsp.buf.hover()
end)

-- vim.keymap.set('n', 'gh', function() vim.lsp.buf.signature_help() end)
vim.keymap.set('n', 'gF', '<cmd>Format<cr>', { desc = 'Format current buffer' })
