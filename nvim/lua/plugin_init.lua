-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "https://github.com/drewtempelmeyer/palenight.vim",

  -- easily move around
  -- Plug "easymotion/vim-easymotion"
  -- Plug 'https://github.com/ggandor/lightspeed.nvim'
  "https://github.com/ggandor/leap.nvim",

  -- show the yank
  "https://github.com/machakann/vim-highlightedyank",

  -- fuzzy search: is made better with ripgrep
  "https://github.com/junegunn/fzf", { cmd = "~/opt/fzf", cmd = "./install --all" },
  'https://github.com/junegunn/fzf.vim',

  -- git integration
  'https://github.com/tpope/vim-fugitive',

  -- smart set shiftwidth
  'https://github.com/tpope/vim-sleuth',

  -- make changing surrounds easier
  'https://github.com/tpope/vim-surround',

  -- make comments easier
  'https://github.com/tpope/vim-commentary',

  -- use repeat with plugins
  'https://github.com/tpope/vim-repeat',

  -- some nice keyboard mappings (including bubbling)
  'https://github.com/tpope/vim-unimpaired',

  -- directory stuff by tpope
  'https://github.com/tpope/vim-eunuch',

  -- smart substitute by tpope
  'https://github.com/tpope/vim-abolish',

  -- tpope's async stuff
  'https://github.com/tpope/vim-dispatch',

  -- bottom status bar
  'https://github.com/vim-airline/vim-airline',

  -- auto make close pairs
  'https://github.com/jiangmiao/auto-pairs',

  -- typescript
  'https://github.com/HerringtonDarkholme/yats.vim',

  -- autoformant, i.e. beautify (used mostly for html)
  'https://github.com/Chiel92/vim-autoformat',

  -- javascript syntax
  'https://github.com/pangloss/vim-javascript',

  -- markdown previewer
  'https://github.com/iamcco/markdown-preview.nvim', { cmd = 'cd app && yarn install' },

  -- Undo branching visualization
  'https://github.com/simnalamburt/vim-mundo',

  -- Better search highlighting
  'https://github.com/haya14busa/incsearch.vim',

  -- Better project searching
  'https://github.com/wincent/ferret',

  -- Close all buffers but current/specified one
  'https://github.com/schickling/vim-bufonly',

  -- Visual star
  'https://github.com/bronson/vim-visual-star-search',

  -- git gutter
  'https://github.com/airblade/vim-gitgutter',

  -- sort motion
  'https://github.com/christoomey/vim-sort-motion',

  -- edit macros
  'https://github.com/dohsimpson/vim-macroeditor',

  -- sane window removal management
  'https://github.com/mhinz/vim-sayonara',

  -- alignment
  'https://github.com/junegunn/vim-easy-align',

  -- css colors
  'https://github.com/ap/vim-css-color',

  -- A dep for diff and lsp
  'https://github.com/nvim-lua/plenary.nvim',

  -- Diff stuff
  'https://github.com/sindrets/diffview.nvim',

  -- CoC
  'https://github.com/neoclide/coc.nvim', { cmd = 'yarn install --frozen-lockfile' },

  -- Start screen
  'https://github.com/mhinz/vim-startify',

  -- Better matching
  'https://github.com/andymass/vim-matchup',

  -- Whitespace trimmer
  'https://github.com/KorySchneider/vim-trim',

  -- dev icons
  'https://github.com/kyazdani42/nvim-web-devicons',

  -- file tree
  'https://github.com/kyazdani42/nvim-tree.lua',

  -- neovim lsp stuff
  'https://github.com/neovim/nvim-lspconfig', -- the main lsp module
  'https://github.com/jose-elias-alvarez/null-ls.nvim',
  'https://github.com/folke/trouble.nvim', -- diagnostic window

  -- docs
  'https://github.com/kkoomen/vim-doge',

  -- testing
  'https://github.com/vim-test/vim-test',

  -- vimux
  'https://github.com/preservim/vimux',

  -- terraform
  'https://github.com/hashivim/vim-terraform',

  -- helm
  "https://github.com/towolf/vim-helm",
})
