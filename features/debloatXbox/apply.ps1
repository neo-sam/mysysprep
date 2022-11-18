#Requires -RunAsAdministrator

Disable-BundledService XblAuthManager, XblGameSave, XboxGipSvc, XboxNetApiSvc

if (!(Test-Windows7)) {
    Disable-BundledTask XblGameSaveTask
}

Uninstall-BundledAppx @'
Microsoft.Xbox.TCUI
Microsoft.XboxIdentityProvider
Microsoft.XboxApp
Microsoft.XboxGameOverlay
Microsoft.XboxGamingOverlay
Microsoft.XboxSpeechToTextOverlay
'@
