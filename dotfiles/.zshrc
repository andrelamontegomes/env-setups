export TERM=xterm-256color
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/dev-scripts:$PATH

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin
export ANDROID_HOME=$HOME/android_sdk/cmdline-tools/latest
export ANDROID_SDK_ROOT=$HOME/android_sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/cmdline-tools/tools/bin
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
export PATH=$PATH:$ANDROID_HOME/bin
export WSL_HOST="192.168.1.254"
export ADB_SERVER_SOCKET=tcp:$WSL_HOST:5037

# GUI and Electron setup
export DISPLAY="`grep nameserver /etc/resolv.conf | sed 's/nameserver //'`:0"

alias adb="$ANDROID_SDK_ROOT/platform-tools/adb"
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

# Macros 
alias tp="cd $HOME && vim $HOME/todo/personal.md"
alias tg="cd $HOME && vim $HOME/todo/gss.md"

# Windows applications alias
alias clip="clip.exe <"
alias open="explorer.exe"

# Heroku alias
alias hrrc="heroku run rails console"
alias hrr="heroku run rails console"
alias hrp="--remote production"
alias hrs="--remote staging"

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
alias gs="git status --short -uno"
alias gnvm="git reset --soft HEAD~1"

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
