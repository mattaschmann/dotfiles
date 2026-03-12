# # Uncomment this and the bottom one for profiling
# zmodload zsh/zprof

# 10ms for key sequences
KEYTIMEOUT=1

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=13

# to disable duplicates in zsh history
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_BEEP

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(kubectl)

source $ZSH/oh-my-zsh.sh

# Theme
ZSH_THEME=""

# os specific stuff
if [[ "$(uname)" == "Darwin" ]]; then # osx
  eval "$(ssh-agent)" > /dev/null
  ssh-add --apple-use-keychain -q ~/.ssh/gitlab ~/.ssh/github
elif [[ "$(uname -r)" == *"WSL2" ]]; then # wsl2
  eval "$(keychain --quiet --eval github)"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
fi

# antidote
source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh
antidote load

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
alias dirsize="du -h -d 1 | sort -rh"

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

# kubectl aliases
alias k="kubectl"
alias ktx="kubectx"

# for "activating" a .env file
alias ve='export $(grep -v '^#' .env | xargs)'

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

# docker compose
alias c="docker compose"

# make nvim the default editor
export EDITOR=nvim
# make nvim the default manpager
export MANPAGER='nvim --clean +Man!'

# FZF
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

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
export PATH="$HOME/.local/bin:$PATH"

# rust
export PATH="$HOME/.cargo/bin:$PATH"

# fnm
eval "$(fnm env --use-on-cd --shell zsh)"

# starship prompt
# see: https://starship.rs/
eval "$(starship init zsh)"

# remember cd's
eval "$(zoxide init zsh)"

# yazi
function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# uv
source "$HOME/.dotfiles/uv/uv_shell.sh"

# certs
export NODE_EXTRA_CA_CERTS="$HOME/org-ca-bundle.pem"

# for profiling, should be at bottom
# zprof
