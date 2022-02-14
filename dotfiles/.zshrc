export PATH=$PATH:$HOME/workspace/_utils

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
  copydir
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

########################################
### Plugins configuration
########################################
ZVM_LINE_INIT_MODE=$ZVM_MODE_NORMAL
unsetopt AUTO_CD 

if [ -f $HOME/.zsh/.alias ]; then
  source $HOME/.zsh/.alias
fi

if [ -f $HOME/.zsh/.paths ]; then
  source $HOME/.zsh/.paths
fi
