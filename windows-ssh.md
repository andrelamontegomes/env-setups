```Powershell
Get-WindowsCapability -Online | ? Name -like 'OpenSSH*'
```

```Powershell
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
```

```Powershell
Set-Service -Name sshd -StartupType 'Automatic'
```

```Powershell
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Users\andre\AppData\Local\wsltty\bin\mintty.exe" -PropertyType String -Force
```

```Powershell
netsh advfirewall firewall add rule name=”SSHD service” dir=in action=allow protocol=TCP localport=22
```

## In settings /etc/ssh/sshd_config
```
PubkeyAuthentication yes
PasswordAuthentication no
```
