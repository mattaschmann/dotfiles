return {
  dir = '~/workspace/opencode-prompt.nvim', -- or your path / GitHub URL
  init = function()
    -- Set config BEFORE the plugin loads (no setup() call).
    vim.g.opencode_prompt_opts = {
      markers = { ['@todos'] = '@Matt TODO' },
      -- server = { username = "opencode", password = "secret" },
    }
  end,
  keys = {
    {
      '<F10>',
      function()
        require('opencode-prompt').toggle()
      end,
      mode = { 'n', 'x' },
      desc = 'OpenCode: toggle prompt',
    },
    {
      '<localleader>o',
      function()
        require('opencode-prompt').add_context()
      end,
      mode = { 'n', 'x' },
      desc = 'OpenCode: add context',
    },
  },
}
