return {
  'https://github.com/ibhagwan/fzf-lua.git',
  -- optional for icon support
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = 'VeryLazy',
  keys = {
    { '<Leader>p', '<cmd>FzfLua commands<cr>',         desc = 'Fuzzy search commands' },
    { '<Leader>e', '<cmd>FzfLua files<cr>',            desc = 'Fuzzy search files' },
    { '<Leader>f', '<cmd>FzfLua live_grep<cr>',        desc = 'Fuzzy find in files' },
    { '<leader>f', 'y:FzfLua grep search=<C-R>0<cr>',  mode = 'v' },
    { '<Leader>l', '<cmd>FzfLua blines<CR>',           desc = 'Fuzzy search lines in current file' },
    { '<Leader>h', '<cmd>FzfLua helptags<CR>',         desc = 'Fuzzy search help' },
    { '<Leader>b', '<cmd>FzfLua buffers<CR>',          desc = 'Fuzzy search buffers' },
    { '<leader>?', '<cmd>FzfLua keymaps<cr>',          desc = 'Search keymaps' },
    { '<leader>r', '<cmd>FzfLua resume<cr>',           desc = 'Resume last  operation' },
    { '"',         '<cmd>FzfLua registers<cr>',        desc = 'Use fzf to select register' },
    -- { '<c-r>',     '<cmd>FzfLua registers<cr>',        mode = 'i'},
    { '<leader>.', '<cmd>FzfLua lsp_code_actions<cr>', desc = 'Code Actions' },
    { 'gr',        '<cmd>FzfLua lsp_references<cr>',   desc = 'Code References' },
  },
  config = function()
    local fzf_lua = require('fzf-lua')
    local actions = require('fzf-lua.actions')
    require('fzf-lua').setup({
      winopts = {
        preview = {
          layout = 'vertical',
        },
      },
      grep = {
        cmd = 'rg --hidden --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e ',
        actions = {
          ['ctrl-r'] = { actions.toggle_ignore }
        },
      },
      files = {
        previewer = false
      },
      lines = {
        previewer = false
      }
    })

    _G.fzf_Matt = function(opts)
      opts = opts or {}
      opts.previewer = 'builtin'
      opts.actions = fzf_lua.defaults.actions.files

      fzf_lua.fzf_exec('rg --column --color=always @Matt', opts)
    end
    vim.keymap.set('n', '<leader>m', _G.fzf_Matt)
  end,
}
