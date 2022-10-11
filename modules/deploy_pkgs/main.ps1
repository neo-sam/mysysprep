$modules = @{ deploy_pkgs = @{} }

. '.\lib\load-commonfn.ps1'
. '.\lib\load-env-with-cfg.ps1'
. '.\lib\load-reghelper.ps1'

$cfg = $modules.deploy_pkgs

if ($null -ne $PSScriptRoot) {
    $script:PSScriptRoot = Split-Path $script:MyInvocation.MyCommand.Path -Parent
}

$envScript = (Get-ChildItem "$PSScriptRoot\_init_.ps1").FullName
$envScriptBlock = [scriptblock]::Create("cd `"$(Get-Location)`";. `"$envScript`"")

$deployTasks = @()
$deployMutexTasks = @()

function Get-PackageFile() {
    [OutputType([IO.FileSystemInfo])] param($pattern)
    return Get-ChildItem "pkgs\$pattern" -ErrorAction SilentlyContinue
}

foreach ($fetchTask in Get-ChildItem '.\pkgs-scripts\*.ps1') {
    $task = & $fetchTask
    if ($null -eq $task.name) { continue }
    if (($null -ne $task.target) -and (Test-Path $task.target -ea 0)) {
        Write-Output "Ignore installed $($task.name)"
        continue
    }
    $task.path = $fetchTask
    if ( $task.mutex ) { $deployMutexTasks += $task }
    else { $deployTasks += $task }
}

mkdir -f .\logs > $null

foreach ($task in $deployTasks) {
    Write-Output "Adding package: $($task.name)"
    Start-Job `
        -InitializationScript $envScriptBlock `
        -Name $task.name -FilePath $task.path | Out-Null
}

Write-Host

function Get-JobOrWait {
    [OutputType([Management.Automation.Job])] param()
    while (Get-Job) {
        if ($job = Get-Job -State Failed | Select-Object -First 1) { return $job }
        if ($job = Get-Job -State Completed | Select-Object -First 1) { return $job }
        if ($job = Get-Job | Wait-Job -Any -Timeout 1) { return $job }
    }
}

while ($job = (Get-JobOrWait)) {
    $name = $job.Name
    try {
        Receive-Job $job -ErrorAction Stop
        Write-Output "Successfully add package: $name." ''
    }
    catch {
        Write-Output "Fail to add package: $name",
        "Reason: $($_.Exception.Message)", ''
    }
    finally {
        Remove-Job $job
    }
}

foreach ($task in $deployMutexTasks) {
    Write-Output "Installing: $($task.name)"
    try {
        $job = Start-Job `
            -InitializationScript $envScriptBlock `
            -Name $task.name -FilePath $task.path
        Wait-Job $job | Receive-Job
        Write-Output "Successfully installed package: $($task.name)."
    }
    catch {
        Write-Output "Fail to install package: $($task.name)",
        "Reason: $($_.Exception.Message)", ''
    }
    finally {
        if ($job) { Remove-Job $job }
    }
}

if ($cfg.createGetVscodeShortcut) {
    $getVscScriptPath = 'C:\Users\Public\get-vscode.ps1'

    $getVscScriptText = Get-Content '.\lib\userscripts\vscode.ps1'
    if ((Get-Culture).Name -eq "zh-CN") {
        $getVscScriptText = $getVscScriptText -replace '(?<=\$rewriteUrl = ).+', '"https://vscode.cdn.azure.cn$path"'
    }
    $getVscScriptText | Out-File -Force $getVscScriptPath

    New-SetupScriptShortcut -lnkname "Get VSCode" -psspath $getVscScriptPath
    Write-Output 'Created a vscode getter shortcut.'
}

if ($cfg.installWsl2) {
    dism /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart /quiet
    dism /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart /quiet
    Write-Output 'Added HyperV support.'
}
