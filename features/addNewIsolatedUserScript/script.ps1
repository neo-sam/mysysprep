#Requires -RunAsAdministrator

# Input parameters
$uappPrefix = 'isoapp-'
$uappGroup = 'isoapps'
$onlyAppYes = New-Object System.Management.Automation.Host.ChoiceDescription '&Yes'
$onlyAppNo = New-Object System.Management.Automation.Host.ChoiceDescription '&No'
$onlyAppOptions = [System.Management.Automation.Host.ChoiceDescription[]]($onlyAppNo, $onlyAppYes)
$onlyApp = $host.ui.PromptForChoice('Will this user have a only application?', $null, $onlyAppOptions, 1) -eq 1
while (1) {
    if ($onlyApp) {
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

$Error.Clear()

# Optimize
Set-ItemProperty HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer ShowRunAsDifferentUserInStart 1

# Hide New User
$hideUsersRegPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList'
if (!(Test-Path $hideUsersRegPath)) { mkdir -f $hideUsersRegPath >$null }
Set-ItemProperty $hideUsersRegPath $username 0

# Create a new user
net user $username /add > $null
if ((Get-ItemPropertyValue HKLM:\SYSTEM\CurrentControlSet\Control\Lsa LimitBlankPasswordUse) -eq 1) {
    $passwordNo = New-Object System.Management.Automation.Host.ChoiceDescription '&No'
    $passwordYes = New-Object System.Management.Automation.Host.ChoiceDescription '&Yes'
    $passwordOptions = [System.Management.Automation.Host.ChoiceDescription[]]($passwordNo, $passwordYes)
    $password = $host.ui.PromptForChoice('Require login password?', $null, $passwordOptions, 0) -eq 1
    if ($password) { net user $username * }
    else {
        Set-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Control\Lsa LimitBlankPasswordUse 0
    }
}
Set-Localuser $username -PasswordNeverExpires $true

if ($onlyApp) {
    New-LocalGroup $uappGroup -ea 0 >$null
    Add-LocalGroupMember $uappGroup $username
}
if ( $null -eq $username ) { $username = Read-Host 'Define your username' }
$homepath = "C:\Users\$username"

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

({
    $env:__COMPAT_LAYER = 'RunAsInvoker'
    function quit {
        Get-Process | Where-Object { @('powershell', 'conhost') -notcontains $_.Name } | Stop-Process -ea 0
        exit
    }
}).ToString().Trim() -split "`n" |`
    ForEach-Object { $_ -replace '^    ', '' } >`
    "$(mkdir -f Documents\WindowsPowerShell)\Microsoft.PowerShell_profile.ps1"

Pop-Location

# Add shortcuts to desktop
$ws = New-Object -ComObject WScript.Shell
$pwshlink = $ws.CreateShortcut("$([Environment]::GetFolderPath('Desktop'))\PowerShell as $username(user).lnk")
$pwshlink.IconLocation = "powershell.exe"
$pwshlink.TargetPath = "%windir%\system32\cmd.exe"
$pwshlink.WorkingDirectory = $homepath
if ($password) {
    $pwshlink.Arguments = "/c `"runas /profile /user:$username ^`"cmd /c cd $homepath ^& powershell ^`"`""
}
else {
    $pwshlink.Arguments = "/c `"echo.|runas /profile /user:$username ^`"cmd /c cd $homepath ^& powershell ^`"`""
}
$pwshlink.Save()
if ($onlyApp) {
    $applink = $ws.CreateShortcut("$([Environment]::GetFolderPath('Desktop'))\EDITME as $appname(app).lnk")
    $applink.IconLocation = "%windir%\system32\shell32.dll,133"
    $applink.TargetPath = "%windir%\system32\cmd.exe"
    if ($password) {
        $applink.Arguments = "/c `"runas /profile /user:$username ^`"EDITME^`"`""
    }
    else {
        $applink.Arguments = "/c `"echo.|runas /profile /user:$username ^`"EDITME^`"`""
    }
    $applink.Save()
}

if ($Error) { Read-Host 'Press Enter Key to close' }
