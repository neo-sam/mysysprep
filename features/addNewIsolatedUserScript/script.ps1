#Requires -RunAsAdministrator

# Input parameters:

$uappPrefix = 'isoapp-'
$uappGroup = 'isoapps'
$onlyapp = $host.ui.PromptForChoice('Will this user have a only application?', $null,
    [System.Management.Automation.Host.ChoiceDescription[]](
    (New-Object System.Management.Automation.Host.ChoiceDescription '&No'),
    (New-Object System.Management.Automation.Host.ChoiceDescription '&Yes')
    ), 1) -eq 1
while (1) {
    if ($onlyapp) {
        Write-Host
        $appname = Read-Host 'Define your app ID (lowercase)'
        if ($appname -eq '') { continue }
        $username = $uappPrefix + $appname
    }
    else {
        $username = Read-Host 'Define your username'
    }
    if ($username -eq '') { Write-Error 'Empty Name!' }
    elseif (Get-LocalUser $username -ea 0) { Write-Error 'User Existed!' }
    else { break }
}

# Optimize:

Set-ItemProperty HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer ShowRunAsDifferentUserInStart 1

# Hide New User:

$hideUsersRegPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList'
if (!(Test-Path $hideUsersRegPath)) { mkdir -f $hideUsersRegPath >$null }
Set-ItemProperty $hideUsersRegPath $username 0

# Create a new user:

net user $username /add > $null
if ((Get-ItemPropertyValue HKLM:\SYSTEM\CurrentControlSet\Control\Lsa LimitBlankPasswordUse) -eq 1) {
    $password = $host.ui.PromptForChoice('Require login password?', $null,
        ([System.Management.Automation.Host.ChoiceDescription[]](
            (New-Object System.Management.Automation.Host.ChoiceDescription '&No'),
            (New-Object System.Management.Automation.Host.ChoiceDescription '&Yes')
        )), 0) -eq 1
    if ($password) { net user $username * }
    else {
        Set-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Control\Lsa LimitBlankPasswordUse 0
    }
}
Set-Localuser $username -PasswordNeverExpires $true

if ($onlyapp) {
    New-LocalGroup $uappGroup -ea 0 >$null
    Add-LocalGroupMember $uappGroup $username
}
if ( $null -eq $username ) { $username = Read-Host 'Define your username' }
$homepath = "C:\Users\$username"
Remove-Item -Recurse -Force -ea 0 $homepath

$Error.Clear()

function runWith {
    param ( [string]$command )
    if ($password) { runas /profile /user:$username $command }
    else { '' | runas /profile /user:$username $command >$null }
}

runWith "cmd /c exit"
if (!(Test-Path $homepath)) {
    net user $username /delete > $null
    Write-Host -ForegroundColor Red 'A problem happend. Please restart your computer to try again!'
    [Console]::ReadKey()>$null
    exit
}

Push-Location $homepath
attrib -h AppData
@('.\Favorites', '.\Links', '.\Saved Games') | ForEach-Object { attrib +h $_ }
icacls . /grant "${env:USERNAME}:(CI)(OI)(F)" >$null
runWith "powershell -wi h -c Set-ExecutionPolicy rem -s c -f"

function Convert-ScriptBlockToText([scriptblock]$block) {
    ($block.ToString() -split "`n" -replace '^    ', '' -join "`n").Trim()
}

(Convert-ScriptBlockToText {
    $env:__COMPAT_LAYER = 'RunAsInvoker'
    function quit {
        Get-Process | Where-Object { @('powershell', 'conhost') -notcontains $_.Name } | Stop-Process -ea 0
        exit
    }
}) > "$(mkdir -f Documents\WindowsPowerShell)\Microsoft.PowerShell_profile.ps1"

Pop-Location

# Add shortcuts to desktop:

$ws = New-Object -ComObject WScript.Shell

$startmenu = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\$username"
if ($onlyapp) {
    $startmenu = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\New Isolated User App ($appname)"
}
mkdir -f $startmenu >$null

$it = $ws.CreateShortcut("$startmenu\PowerShell as user($username).lnk")
$it.IconLocation = "powershell.exe"
$it.TargetPath = "%windir%\system32\cmd.exe"
$it.WorkingDirectory = $homepath
if ($password) { $it.Arguments = "/c `"runas /profile /user:$username ^`"cmd /c cd $homepath ^& powershell ^`"`"" }
else { $it.Arguments = "/c `"echo.|runas /profile /user:$username ^`"cmd /c cd $homepath ^& powershell ^`"`"" }
$it.Save()

if ($onlyapp) {
    $it = $ws.CreateShortcut("$startmenu\EDITME as app($appname).lnk")
    $it.IconLocation = "%windir%\system32\shell32.dll,133"
    $it.TargetPath = "%windir%\system32\cmd.exe"
    if ($password) { $it.Arguments = "/c `"runas /profile /user:$username ^`"EDITME^`"`"" }
    else {
        $it.Arguments = "/c `"echo.|runas /profile /user:$username ^`"EDITME^`"`""
        $it.WindowStyle = 7
    }
    $it.Save()
}

# Add remove shortcut:

$target = "$homepath\removeall.ps1"
(Convert-ScriptBlockToText {
    #Requires -RunAsAdministrator
    $uid = "$(HOSTNAME.EXE)\%username%"
    Get-Process -IncludeUserName | Where-Object { $_.UserName -eq $uid } | Stop-Process
    net user '%username%' /delete
    Remove-Item -Recurse -Force $PSScriptRoot
    Remove-Item -Recurse -Force '%startmenu%'
    if ($Error) { Pause }
}) `
    -replace '%username%', $username `
    -replace '%startmenu%', $startmenu `
    > $target

$path = "$startmenu\Dispose Isolated User($username).lnk"
$it = $ws.CreateShortcut($path)
$it.IconLocation = 'shell32.dll,131'
$it.TargetPath = "powershell.exe"
$it.Arguments = "-exec bypass -file `"$target`""
$it.Save()

$bytes = [System.IO.File]::ReadAllBytes($path)
$bytes[0x15] = $bytes[0x15] -bor 0x20
[System.IO.File]::WriteAllBytes($path, $bytes)

Start-Process $startmenu

if ($Error) { Pause }
