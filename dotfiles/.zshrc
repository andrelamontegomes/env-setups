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

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/alg/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/alg/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/alg/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/alg/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

