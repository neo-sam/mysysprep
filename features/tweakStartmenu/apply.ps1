#Requires -RunAsAdministrator

param($cfg)

if ($cfg.disableWebSearch) {
    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer'
    ) DisableSearchBoxSuggestions 1
}

if ($cfg.disableFileSearch) {
    sc.exe stop wsearch >$null
    sc.exe config wsearch start=disabled >$null
}
