.\_adminrequire.ps1

Write-Host '==> Auto install all of ".\pkgs"'
Write-Host "If prompt installation dialogs, allow and confirm ...`n"

Push-Location ..\pkgs

function Start-InstallJob {
    param($name, $path, $params)
    Write-Host "Start to install $name ..."
    Start-Job -ArgumentList @($path, $params) -Name $name {
        Start-Process -Wait $args[0] $args[1]
    } > $null
}

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

$projectRoot = Split-Path (Split-Path $MyInvocation.MyCommand.Path)

$7zipZstd = '7zip-zstd'
$powershell = 'PowerShell'
$firefox = 'Firefox'
$thunderbird = 'Thunderbird'
$cyberduck = 'Cyberduck'

foreach ($file in Get-ChildItem) {
    $filename = $file.Name
    $path = $file.FullName
    switch -Wildcard ($filename) {
        '7z*-zstd-x64.exe' {
            Start-InstallJob $7zipZstd $path '/S'
        }
        'PowerShell-*-win-x64.msi' {
            Start-InstallJob $powershell $path "/q /norestart /l*v $projectRoot\logs\powershell.log ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=1"
        }
        'Firefox Setup *.exe' {
            Start-InstallJob $firefox $path '/S'
        }
        'Thunderbird Setup *.exe' {
            Start-InstallJob $thunderbird $path '/S'
        }
        'Cyberduck-Installer-*.exe' {
            Start-InstallJob $cyberduck $path '/quiet'
        }
        'SourceHanSerif-VF.ttf.ttc' {
            Add-Font $path
        }
    }
}

Write-Host

function Push-SystemPath {
    param([string]$path)
    if ($env:path -like "*$path*") { return }
    setx /m PATH "$env:path;$path" > $null
}

function Assert-Path {
    param([string]$path)
    Get-ChildItem $path -ea Stop > $null
}

function Get-JobOrWait {
    [OutputType([Management.Automation.Job])]
    param()
    $job = Get-Job -State Failed | Select-Object -First 1
    if ($null -eq $job) { $job = Get-Job -State Completed | Select-Object -First 1 }
    if ($null -eq $job) { $job = Get-Job | Wait-Job -Any }
    return $job
}

While ($job = Get-JobOrWait) {
    try {
        Receive-Job $job 2>$null
        if ($job.State -eq 'Failed') { 
            throw 
        }
        switch ($job.Name) {
            $7zipZstd {
                Assert-Path "$env:ProgramFiles\7-Zip-Zstandard\7zFM.exe"
                Push-SystemPath "$env:ProgramFiles\7-Zip-Zstandard"
            }
            $powershell {
                Assert-Path "$env:ProgramFiles\PowerShell\*\pwsh.exe"
            }
            $firefox { 
                Assert-Path "$env:ProgramFiles\Mozilla Firefox\firefox.exe"
            }
            $thunderbird {
                Assert-Path "$env:ProgramFiles\Mozilla Thunderbird\thunderbird.exe"
            }
            $cyberduck {
                Assert-Path "$env:ProgramFiles\Cyberduck\Cyberduck.exe"
            }
        }
    }
    catch {
        Write-Host "Failed to install $($job.Name):"
        Write-Host $Error "`n"
        continue
    }
    finally {
        Remove-Job $job
    }
    Write-Host "Successfully installed $($job.Name)."
}

Pop-Location