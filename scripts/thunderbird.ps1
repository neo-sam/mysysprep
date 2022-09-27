$pkgfile = Get-PackageFile "Thunderbird Setup *.exe"
if (!$PSSenderInfo) { 
    if ($pkgfile) { 'Thunderbird' }
    return 
}

Start-Process $pkgfile /S
Wait-Process $pkgfile.BaseName

Assert-Path "$env:ProgramFiles\Mozilla Thunderbird\thunderbird.exe"