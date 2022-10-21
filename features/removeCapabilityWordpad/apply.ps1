#Requires -RunAsAdministrator

Wait-Process dism -ea 0

Start-DismMutex {
    dism /online /norestart /remove-capability /quiet '/capabilityname:Microsoft.Windows.WordPad~~~~0.0.1.0' >$null
}
