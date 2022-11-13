#Requires -RunAsAdministrator

Set-Service ssh-agent -StartupType Automatic
Start-Service ssh-agent
