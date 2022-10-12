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
        Write-Output "$(
            Get-Translation 'Ignored installed' `
            -base64cn 5a6J6KOF5bey5b+955WlCg==
        ): $($task.name)"
        continue
    }
    $task.path = $fetchTask
    if ( $task.mutex ) { $deployMutexTasks += $task }
    else { $deployTasks += $task }
}

mkdir -f .\logs > $null

foreach ($task in $deployTasks) {
    Write-Output "$(Get-Translation 'Adding package'`
        -base64cn 5a6J6KOF5byA5aeLCg==
    ): $($task.name)"
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
        Write-Output "$(Get-Translation 'Successfully add package'`
            -base64cn 5a6J6KOF5oiQ5YqfCg==
        ): $name." ''
    }
    catch {
        Write-Output "$(Get-Translation 'Fail to add package'`
            -base64cn 5a6J6KOF5aSx6LSlCg==
        ): $name",
        "$(Get-Translation 'Reason'`
            -base64cn 5Y6f5ZugCg==
        ): $($_.Exception.Message)", ''
    }
    finally {
        Remove-Job $job
    }
}

foreach ($task in $deployMutexTasks) {
    Write-Output "$(Get-Translation 'Installing'`
        -base64cn 5a6J6KOF5LitCg==
    ): $($task.name)"
    try {
        $job = Start-Job `
            -InitializationScript $envScriptBlock `
            -Name $task.name -FilePath $task.path
        Wait-Job $job | Receive-Job
        Write-Output "$(Get-Translation 'Successfully installed package'`
            -base64cn 5a6J6KOF5a6M5oiQCg==
        ): $($task.name)."
    }
    catch {
        Write-Output "$(Get-Translation 'Fail to install package'`
            -base64cn 5a6J6KOF5aSx6LSlCg==
        ): $($task.name)",
        "$(Get-Translation 'Reason'`
            -base64cn 5Y6f5ZugCg==
        ): $($_.Exception.Message)", ''
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
    if ($cfg.devbookDocLink) {
        $url = switch ((Get-Culture).Name) {
            zh-CN { 'https://devbook.littleboyharry.me/zh-CN/docs/devenv/vscode/settings' }
            Default { 'https://devbook.littleboyharry.me/docs/devenv/vscode/settings' }
        }
        $getVscScriptText += "start '$url'`n"
    }
    $getVscScriptText | Out-File -Force $getVscScriptPath

    New-SetupScriptShortcut -psspath $getVscScriptPath `
        -lnkname "$(Get-Translation Get -base64cn 6I635Y+WCg==) VSCode"
    Write-Output (Get-Translation 'Created a vscode getter shortcut.'`
            -base64cn 5Yib5bu65LqGIFZTQ29kZSDlronoo4XnqIvluo8K)
}

if ($cfg.installWsl2) {
    dism /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart /quiet
    dism /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart /quiet
    Write-Output (Get-Translation 'Added HyperV support.'`
            -base64cn 5re75Yqg5LqGIEh5cGVyViDmqKHlnZcK)

    if ($cfg.devbookDocLink) {
        New-DevbookDocShortcut WSL2 docs/setup-mswin/devenv/wsl2
    }
}
