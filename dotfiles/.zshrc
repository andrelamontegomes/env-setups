export TERM=xterm-256color
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/workspace/_utils:$PATH
export PATH=$HOME/forks/ledger:$PATH

export ZSH="/home/andre/.oh-my-zsh"
ZSH_THEME="gruvbox"
SOLARIZED_THEM="dark"
plugins=(
  git 
  wd
  docker
  fast-syntax-highlighting
  rails
  vi-mode
)

source $ZSH/oh-my-zsh.sh

########################################
### Plugins configuration
########################################
# ZVM_LINE_INIT_MODE=$ZVM_MODE_NORMAL

unsetopt AUTO_CD 

########################################
### Windows applications alias
########################################
if uname -r | grep -q 'Microsoft' ; then
  alias clip="clip.exe <"
  alias open="explorer.exe"
  alias subl='/mnt/c/Program Files/Sublime Text/subl.exe'
fi

########################################
### Heroku alias
########################################
alias hrrc="heroku run rails console"
alias hrr="heroku run rails console"
alias hrp="--remote production"
alias hrs="--remote staging"

########################################
### Taskwarrior alias
########################################
alias tt="taskwarrior-tui"
alias task='unset TASKRC && task rc.data.location=~/.task'
alias taskw='export TASKRC=$HOME/.taskrc-bigsunsolar && task rc.data.location=~/.task-bigsunsolar'
alias tpa="taskp add"
alias twa="taskw add"

########################################
### Tmux alias
########################################
alias tls="tmux list-sessions"
alias tn="tmux new-session -t"
alias td="tmux detach"
alias ta="tmux attach-session -t"
alias tr="tmux rename-session -t"
alias tksa="tmux kill-server"
alias tkst="tmux kill-session -t"

########################################
### Bash alias
########################################
alias cp="cp -v"
export LESSOPEN="| src-hilite-lesspipe.sh %s"
export LESS=" -R "
alias less='less -m -N -g -i -J --underline-special --SILENT'
alias more='less'
alias bat='batcat'
alias ls='ls -F'
alias mkdir='mkdir -p'

if command -v rbenv > /dev/null ; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
  export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
fi
