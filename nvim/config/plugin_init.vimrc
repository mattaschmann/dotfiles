" my plugins: see https://github.com/junegunn/vim-plug

" Auto download vim-plug if it doesn't exist
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

" theme
Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep-theme' }

" easily move around
Plug 'easymotion/vim-easymotion'

" show the yank
Plug 'machakann/vim-highlightedyank'

" dep for flash
Plug 'kana/vim-operator-user'

" fuzzy search: is made better with ripgrep
Plug 'junegunn/fzf', { 'dir': '~/opt/fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" git integration
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'jreybert/vimagit'

" smart set shiftwidth
Plug 'tpope/vim-sleuth'

" make changing surrounds easier
Plug 'tpope/vim-surround'

" make comments easier
Plug 'tpope/vim-commentary'

" use repeat with plugins
Plug 'tpope/vim-repeat'

" some nice keyboard mappings (including bubbling)
Plug 'tpope/vim-unimpaired'

" directory stuff by tpope
Plug 'tpope/vim-eunuch'

" smart substitute by tpope
Plug 'tpope/vim-abolish'

" bottom status bar
Plug 'vim-airline/vim-airline'

" filetree
Plug 'scrooloose/nerdtree', { 'on': [ 'NERDTreeToggle', 'NERDTreeFind' ] }

" auto make close pairs
Plug 'jiangmiao/auto-pairs'

" exchange two things
Plug 'tommcdo/vim-exchange'

" async linting
Plug 'w0rp/ale'

" typescript
" @Matt TODO: fix the <> thing breaking the syntax
Plug 'HerringtonDarkholme/yats.vim'
" Plug 'https://github.com/leafgarland/typescript-vim.git'
" Plug 'mhartington/nvim-typescript', { 'do': './install.sh' }
Plug 'mhartington/nvim-typescript', { 'commit': '70e36b80113c2d84663b0f86885320022943dd51' }

" autoformant, i.e. beautify
Plug 'Chiel92/vim-autoformat'

" javascript syntax
Plug 'pangloss/vim-javascript'
" javascript intellisense
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }

" jsx syntax
Plug 'https://github.com/mxw/vim-jsx', { 'for': 'javascript.jsx' }

" markdown previewer
Plug 'shime/vim-livedown'

" Undo branching visualization
Plug 'simnalamburt/vim-mundo'

" Better search highlighting
Plug 'haya14busa/incsearch.vim'

" Better project searching
Plug 'wincent/ferret'

" Task plugin
Plug 'irrationalistic/vim-tasks'

" Completions
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" neosnippets
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/context_filetype.vim'

" rust
Plug 'racer-rust/vim-racer'
Plug 'https://github.com/sebastianmarkow/deoplete-rust'

" Close all buffers but current/specified one
Plug 'schickling/vim-bufonly'

" Visual star
Plug 'bronson/vim-visual-star-search'

" emmet
Plug 'mattn/emmet-vim'

" for prose
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

" git gutter
Plug 'airblade/vim-gitgutter'

" ctag generation
Plug 'ludovicchabant/vim-gutentags'

" sort motion
Plug 'christoomey/vim-sort-motion'

" edit macros
Plug 'dohsimpson/vim-macroeditor'

" html tag matching
Plug 'valloric/matchtagalways'

" sane window removal management
Plug 'mhinz/vim-sayonara'

" alignment
Plug 'junegunn/vim-easy-align'

" dash
Plug 'https://github.com/rizzatti/dash.vim'

call plug#end()

