# Please edit below flags: set 0 to 1 meaning enable it

[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
param()

$oobeSkipEula = 0
$oobeSkipMsLogin = 0

# Disable User Data Collectors
$protectMyUserData = 0
$disableAd = 0

# Disable useless compatibility and error report
$disableUnusedServices = 0

$removeCapabilityPowershellISE = 0
$removeCapabilityWordpad = 0
$removeCapabilityOneDrive = 0

$removeBundledCloudAppxes = 0
$uninstallXbox = 0

$optimzeExplorer = 1
$disableSshdServer = 1

# Windows 11:

$noTaskbarWidgets = 0

if ($removeBundledCloudAppxes) {
    $removeAppxList += @"
Microsoft.BingNews
Microsoft.BingWeather
Microsoft.MicrosoftOfficeHub
Microsoft.Office.OneNote
Microsoft.People
Microsoft.YourPhone
Microsoft.WindowsFeedbackHub
MicrosoftCorporationII.MicrosoftFamily_8wekyb3d8bbwe
Microsoft.Windows.Cortana
Microsoft.549981C3F5F10
Clipchamp.Clipchamp
"@
}

if ($uninstallXbox) {
    $removeAppxList += @"
Microsoft.Xbox.TCUI,
Microsoft.XboxApp,
Microsoft.XboxIdentityProvider,
Microsoft.XboxGameOverlay,
Microsoft.XboxGamingOverlay,
Microsoft.XboxSpeechToTextOverlay
"@
}
