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
Plug 'https://github.com/machakann/vim-highlightedyank'

" fuzzy search: is made better with ripgrep
Plug 'junegunn/fzf', { 'dir': '~/opt/fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" git integration
Plug 'tpope/vim-fugitive'
" Plug 'junegunn/gv.vim' " tree view
" Plug 'jreybert/vimagit' " in place edit

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

" make netrw easier, NOTE: using dirvish now
" Plug 'https://github.com/tpope/vim-vinegar'

" bottom status bar
Plug 'https://github.com/vim-airline/vim-airline'

" auto make close pairs
Plug 'jiangmiao/auto-pairs'

" exchange two things
Plug 'tommcdo/vim-exchange'

" async linting
Plug 'w0rp/ale'

" typescript
" @Matt TODO: fix the <> thing breaking the syntax
Plug 'HerringtonDarkholme/yats.vim'
Plug 'https://github.com/mhartington/nvim-typescript', { 'do': './install.sh' }
" python version
" Plug 'mhartington/nvim-typescript', { 'commit': '70e36b80113c2d84663b0f86885320022943dd51' }

" autoformant, i.e. beautify
Plug 'https://github.com/Chiel92/vim-autoformat'

" javascript syntax
Plug 'pangloss/vim-javascript'
" javascript intellisense
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }

" jsx syntax
Plug 'https://github.com/mxw/vim-jsx'

" markdown previewer
" Plug 'shime/vim-livedown'
Plug 'https://github.com/iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }

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

" A file browser (dirvish)
Plug 'https://github.com/justinmk/vim-dirvish'
" for remote ssh viewing
Plug 'https://github.com/bounceme/remote-viewer'
" for git status
Plug 'https://github.com/kristijanhusak/vim-dirvish-git'

" css colors
Plug 'https://github.com/ap/vim-css-color'

" Directory diff
Plug 'https://github.com/vim-scripts/DirDiff.vim'

" Diff in same file
Plug 'https://github.com/andrewradev/linediff.vim'

" Tabnine
Plug 'https://github.com/tbodt/deoplete-tabnine', { 'do': './install.sh' }

" Plug 'autozimu/LanguageClient-neovim', {
"     \ 'branch': 'next',
"     \ 'do': 'bash install.sh',
"     \ }

call plug#end()

