return {
  'https://github.com/windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = true,
  opts = {
    disable_filetype = {
      'text',
      'markdown',
    },
    check_ts = true,
    ts_config = {
      -- Don't pair inside these node types per filetype
      lua = { 'string', 'comment' },
      python = { 'string', 'comment' },
      -- applies to all filetypes if not specified
    },
  },
}
