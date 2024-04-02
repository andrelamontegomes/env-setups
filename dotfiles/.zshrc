export EDITOR=vim
export WORKSPACE=$HOME/workspace
export PATH=$PATH:$WORKSPACE/_utils
export PATH=$PATH:$WORKSPACE/taskwarrior-tui/target/release
export PATH=$PATH:$HOME/.local/bin
export GPG_TTY=$(tty)
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="spaceship"
SPACESHIP_PROMPT_ORDER=(
  dir           # Current directory section
  git           # Git section (git_branch + git_status)
  #package       # Package version
  node          # Node.js section
  dotnet        # .NET section
  ruby          # Ruby section
  #rust          
  venv          
  docker          
  exec_time     # Execution time
  line_sep      # Line break
  battery       # Battery level and status
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)

COMPLETION_WAITING_DOTS="true"
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

alias ff='vim $(rg . | fzf | cut -d ":" -f 1)'

function ff {
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
setopt AUTO_CD 
 
if [ -f $HOME/.zsh/.alias ]; then
  source $HOME/.zsh/.alias
fi
 
if [ -f $HOME/.zsh/.paths ]; then
  source $HOME/.zsh/.paths
fi
 
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
