-- Options that have to be first
vim.o.pumblend = 10

-- Plugins, see: https://lazy.folke.io/
require("config.lazy")

-- General settings and functions
vim.cmd('source $HOME/.config/nvim/vimscripts/options.vimrc')
vim.cmd('source $HOME/.config/nvim/vimscripts/functions.vimrc')
require('config.commands')
require('config.nvim_lsp')

-- Maps, last
require("config.maps")
