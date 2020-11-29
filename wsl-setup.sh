# Update Ubuntu
echo "Updating Ubuntu"
sudo apt update && sudo apt upgrade -y

# Installing Dependencies
echo "Installing Dependencies"

# Install Node and Yarn
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

# Install other dependencies
sudo apt-get update
sudo apt-get install -y expect curl git python libpq-dev zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nodejs unzip zip

# Search
sudo apt-get install -y bat ack-grep fd fzf silversearcher-ag

# Installing ZSH as default shell
echo "Installing zsh"

sudo apt install -y zsh
chsh $USER -s $(which zsh)
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Rails setup

# rbenv installation
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(rbenv init -)"' >> ~/.zshrc
# exec $SHELL

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.zshrc
# exec $SHELL
rbenv install 2.7.1
rbenv global 2.7.1
ruby -v
gem install bundler

gem install rails -v 6.0.2.1
rbenv rehash
rails -v

# Setup Postgres
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -sc)-pgdg main" > /etc/apt/sources.list.d/PostgreSQL.list'
sudo apt update
sudo apt install -y postgresql-11
sudo service postgresql start
sudo -u postgres createuser $(whoami) -s

# Install Tmux
sudo apt-get install -y automake bison pkg-config libevent-dev libncurses5-dev
rm -rf /tmp/tmux
git clone https://github.com/tmux/tmux.git /tmp/tmux
cd /tmp/tmux
git checkout master
sh autogen.sh
./configure && make
sudo make install
cd
rm -rf /tmp/tmux

# Cleanup
sudo apt remove cmdtest
sudo apt -y autoremove

# Git configuration
cd ~
git config --global color.ui true
git config --global user.name "Andre Gomes"
git config --global user.email "andre@cocoon.build"
git config --global core.editor vim 
