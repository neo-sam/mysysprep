#Requires -RunAsAdministrator

$pkg = Get-ChildItem -ea 0 'gvim*.exe'
$targetPath = 'C:\Program Files (x86)\Vim\vim*\gvim.exe'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'gVim'
        target = $targetPath
    }
}

Start-Process -Wait $pkg /S

# CUSTOM:

Add-SystemPath (Get-ChildItem "C:\Program Files (x86)\Vim\vim*\" -ea Stop).FullName

Set-Location C:\Users\Public\Desktop\
Remove-Item 'gVim Easy *.lnk', 'gVim Read only *.lnk'

$appPath = (Get-ChildItem $targetPath).FullName
foreach ($ext in 'viminfo', 'gitconfig', 'minttyrc', 'bash_history') {
    Set-Item (
        Get-RegItemOrNew "HKLM:\Software\Classes\.$ext"
    ) "${ext}_auto_file"
    Set-Item (
        Get-RegItemOrNew "HKLM:\Software\Classes\${ext}_auto_file\shell\edit\command"
    ) "`"$appPath`" `"%1`""
}
