#Requires -RunAsAdministrator

$pkg = Get-ChildItem -ea 0 'gvim*.exe'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'gVim'
        target = "C:\Program Files (x86)\Vim\vim*\vim.exe"
    }
}

Start-Process -Wait $pkg /S

Push-SystemPath (Get-ChildItem "C:\Program Files (x86)\Vim\vim*\" -ea Stop).FullName

Set-Location C:\Users\Public\Desktop\
Remove-Item 'gVim Easy *.lnk', 'gVim Read only *.lnk'
