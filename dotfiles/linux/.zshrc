export TERM=xterm-256color
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/dev-scripts:$PATH
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin
export ANDROID_HOME=~/Android
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools

export ZSH="/home/andre/.oh-my-zsh"
ZSH_THEME="gruvbox"
SOLARIZED_THEM="dark"
plugins=(
  git 
  wd
  fast-syntax-highlighting
  rails
  vi-mode
)

source $ZSH/oh-my-zsh.sh

# Windows applications alias
alias clip="clip.exe <"
alias open="explorer.exe"

# Tmux alias
alias tls="tmux list-sessions"
alias tn="tmux new-session -t"
alias td="tmux detach"
alias ta="tmux attach-session -t"
alias tr="tmux rename-session -t"
alias tksa="tmux kill-server"
alias tkst="tmux kill-session -t"

# Git alias
alias gmf="git merge --no-ff"
alias gb="git branch | cat"

# Bash alias
alias cp="cp -v"
alias ls="ls -a"
export LESSOPEN="| src-hilite-lesspipe.sh %s"
export LESS=" -R "
alias less='less -m -N -g -i -J --underline-special --SILENT'
alias more='less'

alias ptodo='vim ~/todo/personal.md'
alias gtodo='vim ~/todo/gss.md'

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/andre/.sdkman"
[[ -s "/home/andre/.sdkman/bin/sdkman-init.sh" ]] && source "/home/andre/.sdkman/bin/sdkman-init.sh"
