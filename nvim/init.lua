-- Plugins, see: https://lazy.folke.io/
require("config.lazy")

-- General settings and functions
vim.cmd('source $HOME/.config/nvim/vimscripts/options.vimrc')
vim.cmd('source $HOME/.config/nvim/vimscripts/functions.vimrc')
require('config.commands')

-- Maps, last
require("config.maps")
