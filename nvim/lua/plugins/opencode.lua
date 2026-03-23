return {
  'https://github.com/nickjvandyke/opencode.nvim',
  version = '*', -- Latest stable release
  config = function()
    ---@type opencode.Opts

    vim.o.autoread = true -- Required for `opts.events.reload`

    vim.keymap.set({ 'n', 'x' }, '<C-a>', function()
      require('opencode').ask('@this: ', { submit = true })
    end, { desc = 'Ask opencode…' })
    vim.keymap.set({ 'n', 'x' }, '<C-x>', function()
      require('opencode').select()
    end, { desc = 'Execute opencode action…' })
    vim.keymap.set({ 'n', 'x' }, '<LocalLeader><Tab>', function()
      require('opencode').command('agent.cycle')
    end, { desc = 'Cycle agents' })
  end,
}
