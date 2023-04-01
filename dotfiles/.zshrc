export WORKSPACE=$HOME/workspace
export OBSIDIAN=$WORKSPACE/obsidian
export PATH=$PATH:$WORKSPACE/_utils
export PATH=$PATH:$HOME/.local/bin
export EDITOR=vim

GPG_TTY=$(tty)
export GPG_TTY

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="onedark"
plugins=(
  git 
  rails
  ruby
  docker
  sudo
  vi-mode
  wd
  copypath
  copyfile
  dirhistory
  history
  jsontools
  fast-syntax-highlighting
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

function zshaddhistory() {
  echo "${1%%$'\n'}|${PWD}    " >> ~/.zsh_history_ext
}

NOW="$(date +%F-%H:%M:%S)"
TODAY="$(date +%F)"
TS="$(date +%s)"
#NETWORK="$(/sbin/ifconfig | head -n1 | awk -F: '{print $1}')"

function .. { cd ".." ; }
function ... { cd "../.." ; }
function .... { cd "../../.." ; }

function f {
  find . -iname "*${1}*" }

function fd {
  find . -iname "*${1}*" -type d }

function backup () { 
  cp -v "${1}" "${1}.${TS}" }

function grep_ip {
  grep -Eo \
    "([0-9]{1,3}\.){3}[0-9]{1,3}" "${@}" }

function grep_url {
  grep -Eo \
    "(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|.;]*[-A-Za-z0-9\+&@#/%=~_|]" "${@}" }

# ########################################
# ### Plugins configuration
# ########################################
 ZVM_LINE_INIT_MODE=$ZVM_MODE_NORMAL
 unsetopt AUTO_CD 
 
if [ -f $HOME/.zsh/.alias ]; then
  source $HOME/.zsh/.alias
fi
 
if [ -f $HOME/.zsh/.paths ]; then
  source $HOME/.zsh/.paths
fi
 
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/alg/.gcloud/path.zsh.inc' ]; then . '/home/alg/.gcloud/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/alg/.gcloud/completion.zsh.inc' ]; then . '/home/alg/.gcloud/completion.zsh.inc'; fi
