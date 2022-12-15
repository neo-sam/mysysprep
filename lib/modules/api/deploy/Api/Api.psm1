$returnFnFalse = { $false }
$returnFnTrue = { $true }
function Get-BooleanReturnFn([bool]$value) {
    if ($value) { $returnFnTrue } else { $returnFnFalse }
}

function Start-ProcessToInstall([string]$FilePath, [string]$ArgumentList) {
    if ($exitCode = (
            Start-Process -Wait $FilePath $ArgumentList
        ).ExitCode
    ) {
        Write-Error "Failed install code($exitCode)"
    }
}

function Move-DesktopIconFromPublicToDefaultAndCurrentUserIfAuditMode([string]$pattern) {
    if (Test-AuditMode) {
        $path = "C:\Users\Public\Desktop\$pattern.lnk"
        Copy-Item $path 'C:\Users\Default\Desktop'
        Move-Item $path ([Environment]::GetFolderPath('Desktop')) -Force
    }
}

function Assert-7z {
    Get-Item './7z.exe' | Out-Null
}
