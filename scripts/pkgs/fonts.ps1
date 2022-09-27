return

function Add-Font {
    param($path)
    $FontFile = Get-ChildItem $path
    # https://gist.github.com/anthonyeden/0088b07de8951403a643a8485af2709b?permalink_comment_id=3651336#gistcomment-3651336
    $SystemFontsPath = "$env:SystemRoot\Fonts"
    $targetPath = Join-Path $SystemFontsPath $FontFile.Name
    if (Test-Path -Path $targetPath) {
        Write-Host ($FontFile.Name + " already installed")
    }
    else {
        #Extract Font information for Reqistry 
        $ShellFolder = (New-Object -COMObject Shell.Application).Namespace((Split-Path $path))
        $ShellFile = $ShellFolder.ParseName($FontFile.name)
        $ShellFileType = $ShellFolder.GetDetailsOf($ShellFile, 2)

        #Set the $FontType Variable
        If ($ShellFileType -Like '*TrueType font file*') { $FontType = '(TrueType)' }
			
        #Update Registry and copy font to font directory
        $RegName = $ShellFolder.GetDetailsOf($ShellFile, 21) + ' ' + $FontType
        New-ItemProperty -Name $RegName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $FontFile.name -Force | out-null
        Copy-item $FontFile.FullName -Destination $SystemFontsPath
        Write-Host "Added font:" $FontFile.Name
    }
}
