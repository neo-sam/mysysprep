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
    elseif (Get-LocalUser $username -ea sil) { Write-Error 'User Existed!' }
    else { break }
}

# Optimize
reg add HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer /v ShowRunAsDifferentUserInStart /t REG_DWORD /d 1 /f >$null

# Create a new user
net user $username /add > $null
if ((Get-ItemPropertyValue HKLM:\SYSTEM\CurrentControlSet\Control\Lsa LimitBlankPasswordUse) -eq 1) {
    $passwordNo = New-Object System.Management.Automation.Host.ChoiceDescription '&No'
    $passwordYes = New-Object System.Management.Automation.Host.ChoiceDescription '&Yes'
    $passwordOptions = [System.Management.Automation.Host.ChoiceDescription[]]($passwordNo, $passwordYes)
    $password = $host.ui.PromptForChoice('Require login password?', $null, $passwordOptions, 0) -eq 1
    if ($password) { net user $username * }
    else {
        reg add HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v LimitBlankPasswordUse /t REG_DWORD /d 0 /f >$null
    }
}
Set-Localuser $username -PasswordNeverExpires $true
reg add 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList' /v $username /t REG_DWORD /d 0 /f >$null
if ($onlyApp) {
    New-LocalGroup $uappGroup -ea sil >$null
    Add-LocalGroupMember $uappGroup $username
}
if ( $null -eq $username ) { $username = Read-Host 'Define your username' }
function runWith {
    param ( [string]$command )
    if ($password) { runas /profile /user:$username $command }
    else { '' | runas /profile /user:$username $command >$null }
}
$homepath = "C:\Users\$username"
runWith "cmd /c exit"
Push-Location $homepath
attrib -h AppData
@('.\Favorites', '.\Links', '.\Saved Games') | ForEach-Object { attrib +h $_ }
icacls . /grant "${env:USERNAME}:(CI)(OI)(F)" >$null
mkdir -f Documents\WindowsPowerShell >$null
runWith "powershell -wi h -c Set-ExecutionPolicy rem -s c -f"
"`$env:__COMPAT_LAYER = 'RunAsInvoker'`nSet-PSReadLineOption -EditMode Emacs" > "Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
Pop-Location

# Add shortcuts to desktop
$ws = New-Object -ComObject WScript.Shell
$pwshlink = $ws.CreateShortcut("$([Environment]::GetFolderPath("Desktop"))\PowerShell as $username(user).lnk")
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
    $applink = $ws.CreateShortcut("$([Environment]::GetFolderPath("Desktop"))\EDITME as $appname(app).lnk")
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
