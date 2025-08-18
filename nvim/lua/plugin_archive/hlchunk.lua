return {
  'https://github.com/shellRaining/hlchunk.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local fn = vim.fn

    local function get_color(group, attr)
      return fn.synIDattr(fn.synIDtrans(fn.hlID(group)), attr)
    end

    require('hlchunk').setup({
      chunk = {
        enable = true,
        style = {
          get_color('LineNr', 'fg#'),
          get_color('ErrorMsg', 'fg#'),
        },
        duration = 0,
        delay = 0,
      },
    })
  end,
}
