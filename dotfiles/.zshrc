export WORKSPACE=$HOME/workspace
export OBSIDIAN=$WORKSPACE/obsidian
export PATH=$PATH:$WORKSPACE/_utils
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

if uname | grep -q 'Darwin' ; then
  export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin/
  export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
  export SDKROOT=$(xcrun --show-sdk-path)
fi

if command -v gem > /dev/null ; then
  export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
  export PATH="$PATH:$GEM_HOME/bin"
fi

if command -v rbenv > /dev/null ; then
  if uname | grep -q 'Darwin' ; then
    eval "$(rbenv init -)"
  else
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
  fi
fi

if command -v pip3 > /dev/null ; then
  export PATH="$PATH:$HOME/.local/bin"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
