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
$lnkname = "$(Get-Translation 'Install' -cn '安装') AltSnap"
New-SetupScriptShortcut -psspath $scriptPath -lnkname $lnkname

$parts = ((Get-Content '.\modules\deploy\config\altsnap.ps1') -join "`n") -split '; config here'
$content = @(
    $parts[0],
    ((Get-Content '.\modules\deploy\config\altsnap.ini') -join "`n"),
    $parts[1]
) -join ""
if ((Get-WinSystemLocale).Name -eq 'zh-CN') {
    $content = $content -replace '(?<=Language=)en-US', 'zh-CN'
}
$content += "rm -fo `"`$([Environment]::GetFolderPath('Desktop'))\$lnkname.lnk`"`n"
$content > $scriptPath
