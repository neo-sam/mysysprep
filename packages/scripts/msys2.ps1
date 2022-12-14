#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-Item -ea 0 'msys2-x86_64-latest.tar.xz'
$installFolder = 'C:'

$startMenuName = 'MSYS2'

$appdir = "$installFolder\msys64"
if ($GetMetadata) {
    return @{
        name   = 'MSYS2'
        match  = $match
        ignore = Get-BooleanReturnFn (Test-Path $appdir\msys2_shell.cmd)
    }
}

compact.exe /c $(mkdir -f $appdir) | Out-Null

Assert-7z

$tmpfile = "$env:TEMP\$($match.BaseName)"
& ./7z.exe x -txz "-o$env:TEMP" $match -y | Out-Null
& ./7z.exe x -ttar -aos "-o$installFolder" $tmpfile -y | Out-Null
Remove-Item $tmpfile

Set-Location $appdir
& ./autorebase.bat
Add-SystemPath .

foreach ($file in Get-ChildItem -File .) {
    compact.exe /u $file | Out-Null
}
foreach ($path in @('dev', 'etc', 'home', 'opt', 'tmp', 'var')) {
    compact.exe /u $path | Out-Null
}

Move-Item 'etc/post-install/07-pacman-key.post' 'usr/bin/update-pacman-key'

if (Test-Path ($minttyGenerator = "$(Get-ProjectLocation)\features\customMintty\codegen.ps1")) {
    & $minttyGenerator | Out-FileUtf8NoBom "$appdir\etc\minttyrc"
}

try {
    & ./msys2_shell.cmd -defterm -no-start -c 'pacman-key --init && pacman-key --populate msys2' 2>&1 | Out-Null
}
catch {}
Get-Process gpg-agent | Where-Object { $_.Path -like "$appdir\usr\bin\gpg-agent.exe" } | Stop-Process

foreach (
    $programName in @(
        'mingw32'
        'mingw64'
        'ucrt64'
        'clang64'
        'msys2'
    )
) {
    (New-StartMenuShortcut "$appdir\$programName.exe" "$startMenuName $($programName.ToUpper())" $startMenuName).Save()
}
