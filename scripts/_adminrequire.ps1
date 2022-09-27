if (!$Global:ignore_adminrequire -and
    !([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
        
    Write-Error 'Require run as Administrator!'
    exit
}
   
