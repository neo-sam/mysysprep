#Requires -RunAsAdministrator

if (!$PSSenderInfo) {
    foreach ($item in @(
            Get-ChildItem -ea 0 '03_NotoSansCJK-OTC.zip'
            Get-ChildItem -ea 0 '13_NotoSansMonoCJKsc.zip'
            Get-ChildItem -ea 0 'SourceHanSerif-VF.ttf.ttc'
        ) ) {
        if ($item) {
            return @{
                name = 'fonts'
            }
        }
    }
    return
}

$tmpdir = "$(mkdir -f "$env:TMP\win-sf\fonts")"

if (($it = Get-ChildItem -ea 0 '03_NotoSansCJK-OTC.zip') `
        -and !(Test-Path C:\Windows\Fonts\NotoSansCJK*)
) {
    Expand-Archive -Force $it $tmpdir
    Write-Output 'Will add font: Noto Sans CJK'
}
if (($it = Get-ChildItem -ea 0 '13_NotoSansMonoCJKsc.zip') `
        -and !(Test-Path C:\Windows\Fonts\NotoSansMonoCJKsc*)
) {
    Expand-Archive -Force $it $tmpdir
    Write-Output 'Will add font: Noto Sans Mono CJK'
}
if (($it = Get-ChildItem -ea 0 'SourceHanSerif-VF.ttf.ttc')`
        -and !(Test-Path C:\Windows\Fonts\SourceHanSerif*)
) {
    Copy-Item $it $tmpdir
    Write-Output 'Will add font: Source Han Serif'
}

$FontSourceFolder = $tmpdir

$PathToLMWindowsFonts = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"
$SystemFontsPath = "$env:SystemRoot\Fonts"

foreach ($FontFile in Get-ChildItem $FontSourceFolder -Include '*.ttf', '*.ttc', '*.otf' -Recurse) {
    if (Test-Path "$SystemFontsPath\$($FontFile.Name)") { continue }
    Try {
        # Extract Font information for Reqistry
        $ShellFolder = (New-Object -COMObject Shell.Application).Namespace($FontSourceFolder)
        $ShellFile = $ShellFolder.ParseName($FontFile.Name)
        $ShellFileType = $ShellFolder.GetDetailsOf($ShellFile, 2)
        If ($ShellFileType -Like '*TrueType font file*') { $FontType = '(TrueType)' }

        # Update Registry and copy Font to Font directory
        $RegName = $ShellFolder.GetDetailsOf($ShellFile, 21) + ' ' + $FontType
    }
    Catch {
        # This may not be the better way, but this workaround worked
        $FontType = '(OpenType)'
        $RegName = ""
        $NameHelper = $FontFile.Name.Replace("-", " ").Replace("_", " ").Replace(".ttf", "").Replace(".ttc", "").Replace(".otf", "").Trim(" ")
        $NameHelper = $NameHelper.Replace("Mono", " Mono").Replace("NF", " NF").Replace("NL", " NL").Trim(" ")
        $NameHelper = $NameHelper.Replace("Thin", " Thin").Replace("Semi", " Semi").Replace("Medium", " Medium").Replace("Extra", " Extra").Trim(" ")
        $NameHelper = $NameHelper.Replace("Bold", " Bold").Replace("Italic", " Italic").Replace("Light", " Light").Replace("Regular", " Regular").Trim(" ")
        $NameHelper = $NameHelper + " " + $FontType

        ForEach ($Item in $NameHelper.Split(" ")) {
            If (($Item -ne " ") -or ($null -ne $Item)) {
                $RegName = $RegName.Trim(" ") + " " + $Item.Trim(" ")
            }
        }
    }

    New-ItemProperty -Path "$PathToLMWindowsFonts" -Name $RegName -PropertyType String -Value $FontFile.Name -Force | Out-Null
    Move-Item $FontFile.FullName $SystemFontsPath

    Write-Output "Added font: $RegName"
}
