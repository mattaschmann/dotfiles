" my plugins: see https://github.com/junegunn/vim-plug
call plug#begin()

" theme
Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep-theme' }

" easily move around
Plug 'easymotion/vim-easymotion'

" show the yank
Plug 'haya14busa/vim-operator-flashy'

" dep for flash
Plug 'kana/vim-operator-user'

" fuzzy search: is made better with ripgrep
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" git integration
Plug 'tpope/vim-fugitive'

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

" bottom status bar
Plug 'vim-airline/vim-airline'

" filetree
Plug 'scrooloose/nerdtree'

" auto make close pairs
Plug 'jiangmiao/auto-pairs'

" exchange two things
Plug 'tommcdo/vim-exchange'

" async linting
Plug 'w0rp/ale'

" typescript syntax
Plug 'leafgarland/typescript-vim'

" autoformant, i.e. beautify
Plug 'Chiel92/vim-autoformat'

" javascript syntax
Plug 'pangloss/vim-javascript'

" jsx syntax
Plug 'mxw/vim-jsx'

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
" Plug 'ervandew/supertab'

" neosnippets
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/context_filetype.vim'

" rust
Plug 'racer-rust/vim-racer'

" Close all buffers but current/specified one
Plug 'schickling/vim-bufonly'

" Visual star
Plug 'bronson/vim-visual-star-search'

" emmet
Plug 'mattn/emmet-vim'

" for prose
Plug 'junegunn/goyo.vim'

call plug#end()

