-- file tree
return {
  'https://github.com/nvim-tree/nvim-tree.lua',
  -- optional for icon support
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { '-', '<cmd>NvimTreeFindFile<cr>' },
    { '<localleader>f', '<cmd>NvimTreeToggle<cr>' },
  },
  config = function()
    local function my_on_attach(bufnr)
      local api = require('nvim-tree.api')

      local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      local function open_in_yazi()
        local node = api.tree.get_node_under_cursor()
        vim.fn.system({ 'tmux', 'split-window', 'yazi', node['absolute_path'] })
      end

      -- default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- custom mappings
      vim.keymap.del('n', 'S', { buffer = bufnr })
      vim.keymap.del('n', 's', { buffer = bufnr })
      vim.keymap.set('n', '<C-s>', api.tree.search_node, opts('Search'))
      vim.keymap.set('n', '<C-o>', api.node.run.system, opts('Run System'))
      vim.keymap.set('n', 'y', open_in_yazi, opts('Open in yazi'))
    end

    vim.o.confirm = true
    vim.api.nvim_create_autocmd('BufEnter', {
      group = vim.api.nvim_create_augroup('NvimTreeClose', { clear = true }),
      callback = function()
        local layout = vim.api.nvim_call_function('winlayout', {})
        if
          layout[1] == 'leaf'
          and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), 'filetype') == 'NvimTree'
          and layout[3] == nil
        then
          vim.cmd('quit')
        end
      end,
    })

    require('nvim-tree').setup({
      disable_netrw = true,
      hijack_netrw = true,
      on_attach = my_on_attach,
    })
  end,
}
