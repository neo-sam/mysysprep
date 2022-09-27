
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
param()

. ..\config

$protectMyUserData = 1
$disableAd = 1
$disableUnusedServices = 1

$removePowershellISE = 1
$removeWordpad = 1
$removeOneDrive = 1

$uninstallBundledCloudApps = 1
$uninstallXbox = 1

$optimzeExplorer = 1
$noTaskbarWidgets = 1

$removeAppxList = @"
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
Microsoft.Xbox.TCUI,
Microsoft.XboxApp,
Microsoft.XboxIdentityProvider,
Microsoft.XboxGameOverlay,
Microsoft.XboxGamingOverlay,
Microsoft.XboxSpeechToTextOverlay
"@

.\todolist.ps1
.\todolist-devenv.ps1
