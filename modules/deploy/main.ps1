. '.\lib\load-commonfn.ps1'
. '.\lib\load-env-with-cfg.ps1'
. '.\lib\load-reghelper.ps1'

$cfg = $modules.deploy

$envScript = (Get-ChildItem "$PSScriptRoot\_init_.ps1").FullName
$envScriptBlock = [scriptblock]::Create("cd `"$(Get-Location)`";. `"$envScript`"")

$deployTasks = @()
$deployMutexTasks = @()

function Get-PackageFile() {
    [OutputType([IO.FileSystemInfo])] param($pattern)
    return Get-ChildItem "pkgs\$pattern" -ErrorAction SilentlyContinue
}

foreach ($fetchTask in Get-ChildItem "$PSScriptRoot\scripts\*.ps1") {
    $task = & $fetchTask
    if ($null -eq $task.name) { continue }
    if (($null -ne $task.target) -and (Test-Path $task.target -ea 0)) {
        Write-Output "$(
            Get-Translation 'Ignored installed' `
            -cn '安装已忽略'
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
        -cn '安装开始'
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
            -cn '安装成功'
        ): $name." ''
    }
    catch {
        Write-Output "$(Get-Translation 'Fail to add package'`
            -cn '安装失败'
        ): $name",
        "$(Get-Translation 'Reason'`
            -cn '原因'
        ): $($_.Exception.Message)", ''
    }
    finally {
        Remove-Job $job
    }
}

foreach ($task in $deployMutexTasks) {
    Write-Output "$(Get-Translation 'Installing'`
        -cn '安装中'
    ): $($task.name)"
    try {
        $job = Start-Job `
            -InitializationScript $envScriptBlock `
            -Name $task.name -FilePath $task.path
        Wait-Job $job | Receive-Job
        Write-Output "$(Get-Translation 'Successfully installed package'`
            -cn '安装完成'
        ): $($task.name)."
    }
    catch {
        Write-Output "$(Get-Translation 'Fail to install package'`
            -cn '安装失败'
        ): $($task.name)",
        "$(Get-Translation 'Reason'`
            -cn '原因'
        ): $($_.Exception.Message)", ''
    }
    finally {
        if ($job) { Remove-Job $job }
    }
}

if ($cfg.installWsl2) {
    dism /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart /quiet
    dism /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart /quiet
    Write-Output (Get-Translation 'Added HyperV support.'`
            -cn '添加了 HyperV 模块')
}

if ($cfg.newIsolatedUser) {
    $target = 'C:\Users\Public\New-IsolatedUser.ps1'
    Copy-Item "$PSScriptRoot\config\New-IsolatedUser.ps1" $target

    $shortcut = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\New Isolated User.lnk"

    $it = (New-Object -ComObject WScript.Shell).CreateShortcut($shortcut)
    $it.IconLocation = 'imageres.dll,73'
    $it.TargetPath = "powershell.exe"
    $it.Arguments = "-exec bypass -file $target"
    $it.Save()

    $bytes = [IO.File]::ReadAllBytes($shortcut)
    $bytes[0x15] = $bytes[0x15] -bor 0x20
    [IO.File]::WriteAllBytes($shortcut, $bytes)

    Write-Output (Get-Translation 'Added new multi user isolation script.'`
            -cn '添加了创建多用户隔离脚本')
}
