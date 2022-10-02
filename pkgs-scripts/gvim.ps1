$pkgfile = Get-PackageFile "gvim*.exe"
if (!$PSSenderInfo) {
    if ($pkgfile) { 'gVim' }
    return
}

Start-Process -PassThru $pkgfile /S | Wait-Process

$path = (Get-ChildItem "C:\Program Files (x86)\Vim\vim*\" -ErrorAction Stop).FullName
Push-SystemPath $path
