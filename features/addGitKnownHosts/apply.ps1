#Requires -RunAsAdministrator

$file = Get-ChildItem known_hosts

Copy-Item $file "$(mkdir -f C:\Users\Default\.ssh)"
if (!(Test-Path ($target = "$env:USERPROFILE\.ssh\known_hosts"))) {
    Copy-Item $file $target
}
