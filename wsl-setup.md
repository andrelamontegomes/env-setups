# Windows Subsystem of Linux Setup

[https://frankpigeon.com/dev-setup-on-windows-10](https://frankpigeon.com/dev-setup-on-windows-10)
Source for configuring WSL2
Insider Build -Fast
Download Windows10 Debloat Script
[https://github.com/Sycnex/Windows10Debloater](https://github.com/Sycnex/Windows10Debloater)

Privacy Settings turn off:
General Tab (all off)
Speech
Inking
Diagnostics
Activty History
Location
Background Apps
App Diagnostics

# Set "Power Settings" to "High performance"

# Disable File indexing: Go to local disk and Turn off for local disk

```powershell
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /f /v BingSearchEnabled /t REG_DWORD /d 0
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /f /v AllowSearchToUseLocation /t REG_DWORD /d 0
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /f /v CortanaConsent /t REG_DWORD /d 0
```

# Install Chocolately Windows Package Manager

```powershell
choco feature enable -n allowGlobalConfirmation
choco install firefox wox sublimetext3 obs-studio brave microsoft-windows-terminal 7zip vlc vscode bitwarden adobereader autohotkey.portable ccleaner filezilla protonmailbridge expressvpn dropbox spotify steam
```

```powershell
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```

# Download Ubuntu from MS Store

```powershell
wsl --set-default-version 2
```

# Disable sudo password

```bash
sudo vim /etc/sudoers
# Under %sudo privileges input:
# user ALL=(ALL:ALL) NOPASSWD:ALL
```

# Configure DNS

# wsl.conf setup
```bash
[automount]
options="metadata,umask=0033"
```

# Update Ubuntu

```bash
sudo apt update && sudo apt upgrade -y
```

# Installing Dependencies

```bash
# Install Node and Yarn
curl -sL [https://deb.nodesource.com/setup_12.x](https://deb.nodesource.com/setup_12.x) | sudo -E bash -
curl -sS [https://dl.yarnpkg.com/debian/pubkey.gpg](https://dl.yarnpkg.com/debian/pubkey.gpg) | sudo apt-key add -
echo "deb [https://dl.yarnpkg.com/debian/](https://dl.yarnpkg.com/debian/) stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
# Install other dependencies
sudo apt-get update
sudo apt-get install -y expect curl git python libpq-dev zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nodejs

# Search
sudo apt-get install -y bat ack-grep fd fzf silversearcher-ag
```

# Installing ZSH as default shell

```bash
sudo apt install -y zsh
chsh $USER -s $(which zsh)
sh -c "$(curl -fsSL [https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh](https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh))"
git clone https://github.com/zdharma/fast-syntax-highlighting.git \
  ~ZSH_CUSTOM/plugins/fast-syntax-highlighting
curl -L https://raw.githubusercontent.com/sbugzu/gruvbox-zsh/master/gruvbox.zsh-theme > ~/.oh-my-zsh/custom/themes/gruvbox.zsh-theme
```

# Rails setup

# rbenv installation

```bash
git clone [https://github.com/rbenv/rbenv.git](https://github.com/rbenv/rbenv.git) ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(rbenv init -)"' >> ~/.zshrc
exec $SHELL
```

```bash
git clone [https://github.com/rbenv/ruby-build.git](https://github.com/rbenv/ruby-build.git) ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.zshrc
exec $SHELL
rbenv install 2.7.1
rbenv global 2.7.1
ruby -v
gem install bundler
```

```bash
gem install rails -v 6.0.2.1
rbenv rehash
rails -v
```

# Setup Postgres

```bash
wget --quiet -O - [https://www.postgresql.org/media/keys/ACCC4CF8.asc](https://www.postgresql.org/media/keys/ACCC4CF8.asc) | sudo apt-key add -
sudo sh -c 'echo "deb [http://apt.postgresql.org/pub/repos/apt/](http://apt.postgresql.org/pub/repos/apt/) $(lsb_release -sc)-pgdg main" > /etc/apt/sources.list.d/PostgreSQL.list'
sudo apt update
sudo apt install -y postgresql-11
sudo service postgresql start
sudo -u postgres createuser $(whoami) -s
```

# Install Tmux

```bash
sudo apt-get install -y automake bison pkg-config libevent-dev libncurses5-dev
rm -rf /tmp/tmux
git clone [https://github.com/tmux/tmux.git](https://github.com/tmux/tmux.git) /tmp/tmux
cd /tmp/tmux
git checkout master
sh [autogen.sh](http://autogen.sh/)
./configure && make
sudo make install
cd
rm -rf /tmp/tmux
```

# Cleanup

```bash
sudo apt remove cmdtest
sudo apt -y autoremove
```

# Git configuration

```bash
cd ~
git config --global color.ui true
git config --global [user.name](http://user.name/) "YOUR NAME"
git config --global user.email ["YOUR@EMAIL.com](mailto:%22YOUR@EMAIL.com)"
git config --global core.editor vim # setting vim as default is optional
ssh-keygen -t rsa -b 4096 -C ["YOUR@EMAIL.com](mailto:%22YOUR@EMAIL.com)"
```

# SSH

Installing ssh on wsl at risk of periodically losing them

# WSLtty setup

Setup & Download WSLtty
Theme: gruvbox
Font: FiraCode ttf
choco install firacode-ttf
