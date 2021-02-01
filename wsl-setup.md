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

## Set "Power Settings" to "High performance"

# Disable File indexing: Go to local disk and Turn off for local disk

```powershell
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /f /v BingSearchEnabled /t REG_DWORD /d 0
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /f /v AllowSearchToUseLocation /t REG_DWORD /d 0
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /f /v CortanaConsent /t REG_DWORD /d 0
```

# Install Chocolately Windows Package Manager

```powershell
choco feature enable -n allowGlobalConfirmation
choco install firefox wox sublimetext3 obs-studio brave microsoft-windows-terminal 7zip vlc vscode bitwarden adobereader autohotkey.portable ccleaner filezilla protonmailbridge expressvpn dropbox spotify steam wsltty firacode powertoys
```

```powershell
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```

### ***Make sure if is built desktop, the BIOS has SVM enabled***

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
# Automatically answer 'yes' with apt-get install
```bash
sudo vim /etc/apt/apt.conf.d/90forceyes
# APT::Get::Assume-Yes "true";
```

# Configure DNS

# wsl.conf setup
```bash
[automount]
options="metadata,umask=0033"
```

# Installing ZSH as default shell
```bash
sudo apt install zsh
chsh $USER -s $(which zsh)
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Add custom themes and plugins
git clone https://github.com/zdharma/fast-syntax-highlighting.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
curl -L https://raw.githubusercontent.com/sbugzu/gruvbox-zsh/master/gruvbox.zsh-theme > ~/.oh-my-zsh/custom/themes/gruvbox.zsh-theme


```

### Follow or Run wsl-setup.sh instructions
[Link to script](https://github.com/gomesac/env-setups/blob/master/wsl-setup.sh)

# Rails setup
```bash
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(rbenv init -)"' >> ~/.zshrc
exec $SHELL

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.zshrc
exec $SHELL
rbenv install 2.7.1
rbenv global 2.7.1
ruby -v
gem install bundler

gem install rails -v 6.0.2.1
rbenv rehash
rails -v
```

# Git configuration
```bash
cd ~
git config --global color.ui true
git config --global user.name "Your name"
git config --global user.email "Your email"
git config --global core.editor vim 
```

# SSH
Installing ssh on wsl at risk of periodically losing them
```bash
cd ~
ssh-keygen -t rsa -b 4096 -C "YOUR@EMAIL.com"
```
