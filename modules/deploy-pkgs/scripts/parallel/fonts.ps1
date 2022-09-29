if (!$PSSenderInfo) { 
    foreach ($item in @(
            Get-PackageFile "03_NotoSansCJK-OTC.zip"
            Get-PackageFile "13_NotoSansMonoCJKsc.zip"
            Get-PackageFile "SourceHanSerif-VF.ttf.ttc"
        ) ) {
        if ($item) { return 'fonts' }
    }
    return 
}

$tmpdir = 'tmp\fonts'

mkdir -f $tmpdir >$null
if ($it = Get-PackageFile "03_NotoSansCJK-OTC.zip") {
    Expand-Archive -Force $it $tmpdir
}
if ($it = Get-PackageFile "13_NotoSansMonoCJKsc.zip") {
    Expand-Archive -Force $it $tmpdir
}
if ($it = Get-PackageFile "SourceHanSerif-VF.ttf.ttc") {
    Copy-Item -Force $it $tmpdir
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

    Write-Host "Added font: $RegName"
}
