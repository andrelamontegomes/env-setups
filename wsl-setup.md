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
choco install firefox wox sublimetext3 obs-studio brave microsoft-windows-terminal 7zip vlc vscode bitwarden adobereader autohotkey.portable ccleaner filezilla protonmailbridge expressvpn dropbox spotify steam wsltty firacode powertoys
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

# Installing ZSH as default shell
sudo apt install -y zsh
chsh $USER -s $(which zsh)
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Follow wsl-setup.sh instructions

# SSH
Installing ssh on wsl at risk of periodically losing them
```bash
cd ~
ssh-keygen -t rsa -b 4096 -C "YOUR@EMAIL.com"
```
