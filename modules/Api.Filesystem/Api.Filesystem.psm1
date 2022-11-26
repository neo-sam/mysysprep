function Copy-ToCurrentDesktop([string]$path) {
    Copy-Item -Force $path ([Environment]::GetFolderPath('Desktop'))
}

function Set-FolderIcon([string]$path, [string]$id) {
    Push-Location $path

    Set-Content desktop.ini -Encoding oem (@"
[.ShellClassInfo]
IconResource=$id
[ViewState]
Mode=
Vid=
FolderType=Generic
"@ -split "`n" -join "`r`n")
    attrib.exe desktop.ini +s +h +a
    attrib.exe +r .

    Pop-Location
}