export TERM="xterm-256color"
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
# export JAVA_HOME=$(/usr/libexec/java_home -v 8)
# export JAVA_OPTS='-XX:+IgnoreUnrecognizedVMOptions --add-modules java.se.ee'
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:Library/Python/3.7/bin

# Path to your oh-my-zsh installation.
export ZSH="/Users/gosmartsolardev/.oh-my-zsh"

ZSH_THEME="agnoster"
plugins=(git wd rails)

source $ZSH/oh-my-zsh.sh

# Comman line calculator aliad
alias calc="bc"
alias calculator="bc"

# Tmux alias
alias tns="tmux new-session -t"
alias td="tmux detach"
alias tas="tmux attach-session -t"
alias trs="tmux rename-session -t"
alias tks="tmux kill-server"
alias tkst="tmux kill-session -t"

DEFAULT_USER=$(whoami)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_STRATEGY=truncate_folders
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER=true
export HOMEBREW_GITHUB_API_TOKEN=edb40e6d924658a574071bf937133ee33dad65ec

# tabtab source for electron-forge package
# uninstall by removing these lines or running `tabtab uninstall electron-forge`
[[ -f /Users/gosmartsolardev/.config/yarn/global/node_modules/tabtab/.completions/electron-forge.zsh ]] && . /Users/gosmartsolardev/.config/yarn/global/node_modules/tabtab/.completions/electron-forge.zsh

### LESS ###
export LESSOPEN="| src-hilite-lesspipe.sh %s"
export LESS=" -R "
alias less='less -m -N -g -i -J --underline-special --SILENT'
alias more='less'
