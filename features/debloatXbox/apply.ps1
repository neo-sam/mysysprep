#Requires -RunAsAdministrator

Disable-BundledService XblAuthManager, XblGameSave, XboxGipSvc, XboxNetApiSvc
Disable-BundledTask XblGameSaveTask

Uninstall-BundledAppx @'
Microsoft.Xbox.TCUI
Microsoft.XboxApp
Microsoft.XboxIdentityProvider
Microsoft.XboxGameOverlay
Microsoft.XboxGamingOverlay
Microsoft.XboxSpeechToTextOverlay
'@
