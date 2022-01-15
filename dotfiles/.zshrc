export TERM=xterm-256color
export PATH=$HOME/workspace/_utils:$PATH

export ZSH="/home/andre/.oh-my-zsh"
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

########################################
### Linux Applications Configuration
########################################
if uname | grep -q 'Linux' ; then
  alias dslr-webcam="gphoto2 --set-config-value whitebalance="Auto" && gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video0"
fi

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
if command -v heroku > /dev/null ; then
  alias hrrc="heroku run rails console"
  alias hrr="heroku run rails console"
  alias hrp="--remote production"
  alias hrs="--remote staging"
fi

########################################
### Tmux alias
########################################
if command -v tmux > /dev/null ; then
  alias tls="tmux list-sessions"
  alias tn="tmux new-session -t"
  alias td="tmux detach"
  alias ta="tmux attach-session -t"
  alias tr="tmux rename-session -t"
  alias tksa="tmux kill-server"
  alias tkst="tmux kill-session -t"

  alias session-monitoring="
    tmux new-session -t monitoring \; \
      send-keys 'htop' C-m \; \
      split-window -v -p 20 \; \
      split-window -h -p 50 \; \
      send-keys 'wd uy' C-m \; \
      select-pane -t 1 \; \
  "
fi

########################################
### Taskwarrior alias
########################################
if command -v task > /dev/null ; then
  alias tw="task"
  alias twa="task add"
  alias twap="task add pro:personal"
  alias twac="task add pro:cocoon"
  alias twab="task add pro:bigsun"
  alias twe="task edit"
  alias twt="task top"
  alias twb="task pro:bigsun"
  alias twp="task pro:personal"
  alias twc="task pro:cocoon"
fi

########################################
### Bash alias
########################################
alias sudo="sudo -v; sudo "
alias cp="cp -v"
export LESSOPEN="| src-hilite-lesspipe.sh %s"
export LESS=" -R "
alias less='less -m -N -g -i -J --underline-special --SILENT'
alias more='less'
#alias bat='batcat'
alias mkdir='mkdir -p'
alias l="LC_COLLATE=C ls --color -lao | grep '^d' && LC_COLLATE=C ls -loa --color | grep '^-' && LC_COLLATE=C ls -la | grep '^l'"

if command -v gem > /dev/null ; then
  export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
  export PATH="$PATH:$GEM_HOME/bin"
fi

if command -v rbenv > /dev/null ; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
  export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
fi
