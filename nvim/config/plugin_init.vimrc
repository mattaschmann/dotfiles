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
Plug 'https://github.com/drewtempelmeyer/palenight.vim'
Plug 'https://github.com/jacoborus/tender.vim'
Plug 'https://github.com/morhetz/gruvbox'

" easily move around
Plug 'easymotion/vim-easymotion'

" show the yank
Plug 'https://github.com/machakann/vim-highlightedyank'

" fuzzy search: is made better with ripgrep
Plug 'junegunn/fzf', { 'dir': '~/opt/fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" git integration
Plug 'tpope/vim-fugitive'

" smart set shiftwidth
Plug 'https://github.com/tpope/vim-sleuth'

" make changing surrounds easier
Plug 'tpope/vim-surround'

" make comments easier
Plug 'tpope/vim-commentary'

" use repeat with plugins
Plug 'tpope/vim-repeat'

" some nice keyboard mappings (including bubbling)
Plug 'https://github.com/tpope/vim-unimpaired'

" directory stuff by tpope
Plug 'tpope/vim-eunuch'

" smart substitute by tpope
Plug 'tpope/vim-abolish'

" tpope's async stuff
Plug 'https://github.com/tpope/vim-dispatch'

" bottom status bar
Plug 'https://github.com/vim-airline/vim-airline'

" auto make close pairs
Plug 'jiangmiao/auto-pairs'

" async linting
" Plug 'w0rp/ale'

" typescript
Plug 'https://github.com/HerringtonDarkholme/yats.vim'

" autoformant, i.e. beautify (used mostly for html)
Plug 'https://github.com/Chiel92/vim-autoformat'

" javascript syntax
Plug 'pangloss/vim-javascript'

" jsx syntax
Plug 'https://github.com/mxw/vim-jsx'

" markdown previewer
Plug 'https://github.com/iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }

" Undo branching visualization
Plug 'https://github.com/simnalamburt/vim-mundo'

" Better search highlighting
Plug 'haya14busa/incsearch.vim'

" Better project searching
Plug 'wincent/ferret'

" Task plugin
Plug 'https://github.com/irrationalistic/vim-tasks'

" Completions
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" neosnippets
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/context_filetype.vim'

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

" sane window removal management
Plug 'mhinz/vim-sayonara'

" alignment
Plug 'junegunn/vim-easy-align'

" A file browser (dirvish)
Plug 'https://github.com/justinmk/vim-dirvish'
" for git status
Plug 'https://github.com/kristijanhusak/vim-dirvish-git'

" css colors
Plug 'https://github.com/ap/vim-css-color'

" Directory diff
Plug 'https://github.com/vim-scripts/DirDiff.vim'

" Diff in same file
Plug 'https://github.com/andrewradev/linediff.vim'

" GraphQL
Plug 'https://github.com/jparise/vim-graphql'

" CoC
Plug 'https://github.com/neoclide/coc.nvim', { 'do': 'yarn install --frozen-lockfile' }

" Start screen
Plug 'https://github.com/mhinz/vim-startify'

" Better matching
Plug 'https://github.com/andymass/vim-matchup'

" gdiff branches
Plug 'https://github.com/oguzbilgic/vim-gdiff'

" whitespace
Plug 'https://github.com/ntpeters/vim-better-whitespace'

" rust
Plug 'https://github.com/arzg/vim-rust-syntax-ext'

call plug#end()

