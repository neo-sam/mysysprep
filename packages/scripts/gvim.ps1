#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-ChildItem -ea 0 'gvim*.exe'
$appmatch = 'C:\Program Files (x86)\Vim\vim*\gvim.exe'

if ($GetMetadata) {
    return @{
        name   = 'gVim'
        match  = $match
        ignore = Get-BooleanReturnFn (Test-Path $appmatch)
    }
}

Start-Process -Wait $match /S

# CUSTOM:

Set-Location C:\Users\Public\Desktop\
Remove-Item 'gVim Easy *.lnk', 'gVim Read only *.lnk'

Add-SystemPath (Get-ChildItem "C:\Program Files (x86)\Vim\vim*\" -ea Stop).FullName

$appPath = (Get-ChildItem $appmatch).FullName
foreach ($ext in 'viminfo', 'gitconfig', 'minttyrc', 'bash_history') {
    Set-Item (
        Get-RegItemOrNew "HKLM:\Software\Classes\.$ext"
    ) "${ext}_auto_file"
    Set-Item (
        Get-RegItemOrNew "HKLM:\Software\Classes\${ext}_auto_file\shell\edit\command"
    ) "`"$appPath`" `"%1`""
}
