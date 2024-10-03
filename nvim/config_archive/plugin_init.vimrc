" my plugins: see https://github.com/junegunn/vim-plug

" Auto download vim-plug if it doesn't exist
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

" theme
" Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep-theme' }
" Plug 'https://github.com/drewtempelmeyer/palenight.vim'
" Plug 'https://github.com/jacoborus/tender.vim'
" Plug 'https://github.com/morhetz/gruvbox'

" easily move around
" Plug 'easymotion/vim-easymotion'
" Plug 'https://github.com/ggandor/lightspeed.nvim'
" Plug 'https://github.com/ggandor/leap.nvim'


" show the yank
" Plug 'https://github.com/machakann/vim-highlightedyank'

" fuzzy search: is made better with ripgrep
" Plug 'junegunn/fzf', { 'dir': '~/opt/fzf', 'do': './install --all' }
" Plug 'junegunn/fzf.vim'

" git integration
" Plug 'https://github.com/tpope/vim-fugitive'

" " smart set shiftwidth
" Plug 'https://github.com/tpope/vim-sleuth'

" " make changing surrounds easier
" Plug 'https://github.com/tpope/vim-surround'

" " make comments easier
" Plug 'https://github.com/tpope/vim-commentary'

" " use repeat with plugins
" Plug 'https://github.com/tpope/vim-repeat'

" " some nice keyboard mappings (including bubbling)
" Plug 'https://github.com/tpope/vim-unimpaired'

" " directory stuff by tpope
" Plug 'https://github.com/tpope/vim-eunuch'

" " smart substitute by tpope
" Plug 'https://github.com/tpope/vim-abolish'

" " tpope's async stuff
" Plug 'https://github.com/tpope/vim-dispatch'

" bottom status bar
" Plug 'https://github.com/vim-airline/vim-airline'

" auto make close pairs
" Plug 'https://github.com/jiangmiao/auto-pairs'

" typescript
" Plug 'https://github.com/HerringtonDarkholme/yats.vim'

" autoformant, i.e. beautify (used mostly for html)
Plug 'https://github.com/Chiel92/vim-autoformat'

" syntax (polyglot)
" Plug 'https://github.com/sheerun/vim-polyglot'
" javascript syntax
" Plug 'https://github.com/pangloss/vim-javascript'

" markdown previewer
Plug 'https://github.com/iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

" Undo branching visualization
" Plug 'https://github.com/simnalamburt/vim-mundo'

" Better search highlighting
" Plug 'https://github.com/haya14busa/incsearch.vim'

" Better project searching
" Plug 'https://github.com/wincent/ferret'

" Close all buffers but current/specified one
" Plug 'https://github.com/schickling/vim-bufonly'

" Visual star
" Plug 'https://github.com/bronson/vim-visual-star-search'

" git gutter
" Plug 'https://github.com/airblade/vim-gitgutter'

" sort motion
" Plug 'https://github.com/christoomey/vim-sort-motion'

" edit macros
" Plug 'https://github.com/dohsimpson/vim-macroeditor'

" sane window removal management
" Plug 'https://github.com/mhinz/vim-sayonara'

" alignment
" Plug 'https://github.com/junegunn/vim-easy-align'

" css colors
" Plug 'https://github.com/ap/vim-css-color'

" A dep for diff and lsp
" Plug 'https://github.com/nvim-lua/plenary.nvim'

" Diff stuff
" Plug 'https://github.com/sindrets/diffview.nvim'

" CoC
Plug 'https://github.com/neoclide/coc.nvim', { 'do': 'npm ci' }

" Start screen
" Plug 'https://github.com/mhinz/vim-startify'

" Better matching
" Plug 'https://github.com/andymass/vim-matchup'

" Whitespace trimmer
" Plug 'https://github.com/KorySchneider/vim-trim'

" todo.txt support
" Plug 'https://github.com/dbeniamine/todo.txt-vim'

" dev icons
" Plug 'https://github.com/kyazdani42/nvim-web-devicons'

" file tree
" Plug 'https://github.com/kyazdani42/nvim-tree.lua'

" neovim lsp stuff
" Plug 'https://github.com/neovim/nvim-lspconfig' " the main lsp module
" Plug 'https://github.com/jose-elias-alvarez/null-ls.nvim'
" Plug 'https://github.com/folke/trouble.nvim' " diagnostic window

" docs
" Plug 'https://github.com/kkoomen/vim-doge', { 'do': { -> doge#install() } }

" testing
" Plug 'https://github.com/vim-test/vim-test'
" Plug 'https://github.com/andythigpen/nvim-coverage'

" vimux
" Plug 'https://github.com/preservim/vimux'

" terraform
" Plug 'https://github.com/hashivim/vim-terraform'

" helm
" Plug 'https://github.com/towolf/vim-helm'

" local config safety
" Plug 'https://github.com/klen/nvim-config-local'

call plug#end()
