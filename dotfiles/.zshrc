export TERM=xterm-256color
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/_util:$PATH

# GUI and Electron setup
export DISPLAY="`grep nameserver /etc/resolv.conf | sed 's/nameserver //'`:0"

alias subl='"/mnt/c/Program Files/Sublime Text/subl.exe"'

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

unsetopt AUTO_CD 

# Windows applications alias
alias clip="clip.exe <"
alias open="explorer.exe"

# Heroku alias
alias hrrc="heroku run rails console"
alias hrr="heroku run rails console"
alias hrp="--remote production"
alias hrs="--remote staging"

# TaskWarrior alias
alias tt="taskwarrior-tui"
alias task='unset TASKRC && task rc.data.location=~/.task'
alias taskw='export TASKRC=$HOME/.taskrc-bigsunsolar && task rc.data.location=~/.task-bigsunsolar'
alias tpa="taskp add"
alias twa="taskw add"

# Tmux alias
alias tls="tmux list-sessions"
alias tn="tmux new-session -t"
alias td="tmux detach"
alias ta="tmux attach-session -t"
alias tr="tmux rename-session -t"
alias tksa="tmux kill-server"
alias tkst="tmux kill-session -t"

# Bash alias
alias cp="cp -v"
export LESSOPEN="| src-hilite-lesspipe.sh %s"
export LESS=" -R "
alias less='less -m -N -g -i -J --underline-special --SILENT'
alias more='less'
alias bat='batcat'

alias mkdir='mkdir -p'

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/andre/.sdkman"
[[ -s "/home/andre/.sdkman/bin/sdkman-init.sh" ]] && source "/home/andre/.sdkman/bin/sdkman-init.sh"
