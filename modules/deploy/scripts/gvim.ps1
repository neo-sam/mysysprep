$pkgfile = Get-PackageFile "gvim*.exe"
if (!$PSSenderInfo) {
    if (-not $pkgfile) { return }
    return @{
        name   = 'gVim'
        target = "C:\Program Files (x86)\Vim\vim*\vim.exe"
    }
}

Start-Process -PassThru $pkgfile /S | Wait-Process

$path = (Get-ChildItem "C:\Program Files (x86)\Vim\vim*\" -ea Stop).FullName
Push-SystemPath $path
