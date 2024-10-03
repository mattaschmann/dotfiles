return {
  'https://github.com/nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local function spellstatus()
      if vim.opt.spell:get() then
        return [[SPELL]]
      else
        return ''
      end
    end

    require('lualine').setup({
      extensions = {
        'quickfix',
        'lazy',
        'fugitive',
        'fzf',
        'man',
        'mundo',
        'nvim-tree',
        'trouble',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { spellstatus, 'filename' },
        lualine_x = { 'filetype' },
        lualine_y = { 'encoding', 'fileformat' },
        lualine_z = { '%l/%L:%c' },
      },
      tabline = {
        lualine_a = { 'buffers' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'tabs' },
      },
    })
  end,
}
