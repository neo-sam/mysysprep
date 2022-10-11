$pkgfile = Get-PackageFile "AltSnap*-x64-inst.exe"
if (!$PSSenderInfo) {
    if (-not $pkgfile) { return }
    return @{
        name   = 'AltSnap'
        target = "$env:APPDATA\AltSnap\AltSnap.exe"
    }
}

Copy-Item $pkgfile 'C:\Users\Public\install-altsnap.exe'

$scriptPath = 'C:\Users\Public\install-altsnap.ps1'
$content = Get-Content '.\lib\userscripts\altsnap.ps1'
if ((Get-WinSystemLocale).Name -eq 'zh-CN') {
    $content = $content -replace '(?<=Language=)en-US', 'zh-CN'
}
$content > $scriptPath

New-SetupScriptShortcut -lnkname "Install AltSnap" -psspath $scriptPath
