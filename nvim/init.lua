-- Plugins, see: https://lazy.folke.io/
require("config.lazy")

-- General settings and functions
require("config.settings")
vim.cmd('source $HOME/.config/nvim/vimscripts/functions.vimrc')
-- require("config.functions")



-- Maps, last
require("config.maps")