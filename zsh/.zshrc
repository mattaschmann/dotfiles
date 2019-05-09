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

# Let antibody manage plugins: https://getantibody.github.io/
# Note: need to re-run 'gen_antibody_sh.sh' in the dotfiles if you add a plugin
source ~/.zsh_plugins.sh

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
alias tm="tmux -2 new -s"
alias ta="tmux attach"
alias n="nvim"

# github specific aliases
alias gb="git branch"
alias gc.="git commit ."
alias gc="git commit"
alias gcp="git commit -p"
alias gd="git diff"
alias gdom="git diff master origin/master --histogram -w"
alias gf="git fetch --prune"
alias gh="git checkout"
alias ghm="git checkout master"
alias gmm="git merge master"
alias gmom="git merge origin/master"
alias gpul="git pull"
alias gpus="git push"
alias gs="git status"

# add term to ssh
alias ssh="TERM=xterm-256color ssh"

# exa alias (for ls'ing)
alias e="exa"

# Functions

# add alias to open man in nvim
nman() { nvim "+Man $1" +BOnly }

export EDITOR=nvim

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

# python
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export PATH="$HOME/Library/Python/3.7/bin:$PATH"

# rust
export PATH="$HOME/.cargo/bin:$PATH"

# mongodb
export PATH="$HOME/opt/mongodb-osx-x86_64-3.6.4/bin:$PATH"

# Ruby stuff
export PATH="/usr/local/opt/ruby/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/ruby/lib"
export CPPFLAGS="-I/usr/local/opt/ruby/include"
export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"

# fnm
eval "$(fnm env --shell=zsh --use-on-cd --multi)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/maschmann/.sdkman"
[[ -s "/Users/maschmann/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/maschmann/.sdkman/bin/sdkman-init.sh"
[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh" # load avn

# zprof
