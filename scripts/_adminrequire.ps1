if (!$env:IGNORE_ADMINREQUIRE -and
    !([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
        
    Write-Error 'Require run as Administrator!' -ErrorAction Stop
}
   
