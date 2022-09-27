$pkgfile = Get-PackageFile "Thunderbird Setup *.exe"
if (!$PSSenderInfo) { 
    if ($pkgfile) { 'Thunderbird' }
    return 
}

Start-Process -PassThru $pkgfile /S | Wait-Process

Assert-Path "C:\Program Files\Mozilla Thunderbird\thunderbird.exe"