# # Uncomment this and the bottom one for profiling
# zmodload zsh/zprof

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
# ENABLE_CORRECTION="true"

# to disable duplicates in zsh history
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_BEEP

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

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

# Theme
ZSH_THEME=""

# Let antibody manage plugins: https://getantibody.github.io/
# Note: need to re-run 'gen_antibody_sh.sh' in the dotfiles if you add a plugin
source ~/.zsh_plugins.sh

# autosuggestions stuff, for some reason only worked when I put it after the plugins
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

# vi mode (for pure)
bindkey -v
# autosuggest
bindkey '^f' autosuggest-accept
# up-down history
bindkey '^n' down-line-or-history
bindkey '^p' up-line-or-history

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias tm="tmux -2 new -s"
alias ta="tmux attach"
alias n="nvim"
# only for linux-based
# alias open="xdg-open"

# github specific aliases
alias gb="git branch"
alias gc.="git commit ."
alias gc="git commit"
alias gd="git diff"
alias gf="git fetch --prune"
alias gh="git checkout"
alias gm="git merge"
alias gpul="git pull"
alias gpus="git push"
alias gs="git status"

# adds an empty git branch, useful for reviewing full repo's
gempty() {
  if [ -n "$1" ]; then
    tree=`git hash-object -wt tree --stdin < /dev/null`
    commit=`git commit-tree -m 'root commit' $tree`
    git branch $1 $commit
  else
    echo "Need the name of the branch as an argument"
  fi
}

# add term to ssh
alias ssh="TERM=xterm-256color ssh"

# exa alias (for ls'ing)
alias e="exa"

# shortcut for finding process
alias psr="ps -A | rg"

# Functions

# make nvim the default editor
export EDITOR=nvim
# make nvim the default manpager
export MANPAGER='nvim +Man!'

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# NOTE: requires fd: https://github.com/sharkdp/fd
FD_OPTIONS="--no-ignore-vcs --hidden --follow --exclude .git --exclude node_modules"
# Change behavior of fzf dialogue: taken from https://medium.com/@alexeysamoshkin/fzf-a-command-line-fuzzy-finder-missing-demo-a7de312403ff
export FZF_DEFAULT_OPTS="--no-mouse --height 50% -1 --multi --inline-info --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300' --preview-window='right:hidden:wrap' --bind='f3:execute(bat --style=numbers {} || less -f {}),f2:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute-silent(echo {+} | pbcopy)'"
# NOTE: use an .ignore file for fd, can be placed anywhere in a parent directory to work
export FZF_DEFAULT_COMMAND="fd --type f --type l $FD_OPTIONS"
export FZF_CTRL_T_COMMAND="fd --type f --type l $FD_OPTIONS"
export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"
_fzf_compgen_path() {
  fd ${=FD_OPTIONS} . "$1"
}
_fzf_compgen_dir() {
  fd --type d ${=FD_OPTIONS} . "$1"
}

# home bin
export PATH="$HOME/bin:$PATH"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# rust
export PATH="$HOME/.cargo/bin:$PATH"

# fnm
export PATH="$HOME/.fnm:$PATH"
eval "$(fnm env --use-on-cd)"

# spark
export PATH="$HOME/opt/spark/bin:$PATH"
export SPARK_HOME="$HOME/opt/spark"

# scala
export PATH="$PATH:$HOME/.local/share/coursier/bin"

# NNN stuff
# run to install all plugins:
# sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"
export NNN_PLUG='c:fzcd;o:fzopen;b:!bat "$nnn"'

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/opt/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/opt/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/opt/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/opt/google-cloud-sdk/completion.zsh.inc"; fi

# terraform
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

source $HOME/.docker/init-zsh.sh || true # Added by Docker Desktop
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
