-- status line
-- Copyright (c) 2020-2021 IGI-111
-- MIT license, see LICENSE for more details.
-- stylua: ignore

-- for palenight
-- local colors = {
--   vertsplit      = '#181A1F',
--   special_grey   = '#3B4048',
--   menu_grey      = '#3E4452',
--   cursor_grey    = '#2C323C',
--   gutter_fg_grey = '#4B5263',
--   blue           = '#82b1ff',
--   dark_red       = '#BE5046',
--   white          = '#bfc7d5',
--   green          = '#C3E88D',
--   purple         = '#9e93de',
--   yellow         = '#ffcb6b',
--   light_red      = '#ff869a',
--   red            = '#ff5370',
--   dark_yellow    = '#F78C6C',
--   cyan           = '#89DDFF',
--   comment_grey   = '#697098',
--   black          = '#292D3E',
-- }
-- local custom_theme = {
--   normal = {
--     a = { fg = colors.black, bg = colors.purple, gui = 'bold' },
--     b = { fg = colors.purple, bg = colors.menu_grey },
--     c = { fg = colors.comment_grey, bg = colors.black },
--   },
--   insert = {
--     a = { fg = colors.black, bg = colors.green, gui = 'bold' },
--     b = { fg = colors.green, bg = colors.menu_grey },
--   },
--   visual = {
--     a = { fg = colors.black, bg = colors.yellow, gui = 'bold' },
--     b = { fg = colors.yellow, bg = colors.menu_grey },
--   },
--   replace = {
--     a = { fg = colors.black, bg = colors.light_red, gui = 'bold' },
--     b = { fg = colors.light_red, bg = colors.menu_grey },
--   },
--   inactive = {
--     a = { fg = colors.black, bg = colors.menu_grey, gui = 'bold' },
--     b = { fg = colors.black, bg = colors.menu_grey },
--     c = { fg = colors.black, bg = colors.menu_grey },
--   },
-- }

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    -- options = {
    --   theme = custom_theme
    -- },
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
    tabline = {
      lualine_a = {'buffers'},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {'tabs'}
    },
  }
}
