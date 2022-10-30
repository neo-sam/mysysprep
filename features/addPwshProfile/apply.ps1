#Requires -RunAsAdministrator

Set-ExecutionPolicy -Scope LocalMachine RemoteSigned
Copy-Item .\profile.ps1 'C:\Windows\System32\WindowsPowerShell\v1.0\'
