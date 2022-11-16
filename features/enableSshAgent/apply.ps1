#Requires -RunAsAdministrator

if ($it = Get-Service -ea 0 ssh-agent) {
    $it | Set-Service -StartupType Automatic
    $it | Start-Service
}
