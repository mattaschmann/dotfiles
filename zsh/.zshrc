# tmux stuff, has to be at the top
# ZSH_TMUX_AUTOSTART=true
# ZSH_TMUX_FIXTERM=true

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# 10ms for key sequences
KEYTIMEOUT=1

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(tmux vi-mode fzf-zsh)

source $ZSH/oh-my-zsh.sh

# Let antigen manage plugins: https://github.com/zsh-users/antigen
source ~/.antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# antigen bundle tmux
antigen bundle vi-mode

antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions

# theme
antigen bundle mafredri/zsh-async
antigen bundle sindresorhus/pure

# this one must be the last plugin
antigen bundle zsh-users/zsh-syntax-highlighting

antigen apply

# Theme
ZSH_THEME=""

# autosuggestions stuff, for some reason only worked when I put it after the plugins
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

autoload -U promptinit; promptinit
prompt pure

# vi mode
bindkey -v
# autosuggest
bindkey '^f' autosuggest-accept

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias tm="tmux -2 new -s default"
alias ta="tmux attach"
alias n="nvim"

# github specific aliases
alias gb="git branch"
alias gpul="git pull"
alias gpus="git push"
alias gchm="git checkout master"
alias gcp="git commit -p"
alias gc.="git commit ."
alias gc="git commit"
alias gs="git status"

export EDITOR=nvim

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# NOTE: requires ripgrep: https://github.com/BurntSushi/ripgrep
# NOTE: use an .ignore file for rg, can be placed anywhere in a parent directory to work
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden --follow --ignore-case 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# NOTE: requires bfs: https://github.com/tavianator/bfs
export FZF_ALT_C_COMMAND="bfs -type d -nohidden 2> /dev/null"

# home bin
export PATH="$HOME/bin:$PATH"

# python
export PATH="/usr/local/opt/python/libexec/bin:$PATH"

# rust
export PATH="$HOME/.cargo/bin:$PATH"

# mongodb
export PATH="$HOME/opt/mongodb-osx-x86_64-3.6.4/bin:$PATH"

# node
export PATH="/usr/local/opt/node@8/bin:$PATH"
