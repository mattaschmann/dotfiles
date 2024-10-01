" lua require('plugin_init')

" vim-plug configuration
source $HOME/.config/nvim/config/plugin_init.vimrc

" general settings and functions
source $HOME/.config/nvim/config/settings.vimrc
source $HOME/.config/nvim/config/functions.vimrc

" specific plugin config, split out to their own files if they get to big for plugin_config.vimrc
source $HOME/.config/nvim/config/plugin_config.vimrc
lua require('plugin_config')

" plugin specific configs, when they get to large for plugin_config
source $HOME/.config/nvim/config/fzf_config.vimrc

" maps, last
source $HOME/.config/nvim/config/maps.vimrc
