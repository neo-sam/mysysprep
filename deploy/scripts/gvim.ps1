#Requires -RunAsAdministrator

$pkg = Get-ChildItem -ea 0 'gvim*.exe'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'gVim'
        target = "C:\Program Files (x86)\Vim\vim*\vim.exe"
    }
}

Start-Process -PassThru $pkg /S | Wait-Process

$path = (Get-ChildItem "C:\Program Files (x86)\Vim\vim*\" -ea Stop).FullName
Push-SystemPath $path
