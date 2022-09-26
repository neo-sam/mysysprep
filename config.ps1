# Please edit below flags: set 0 to 1 meaning enable it
# If you want set all to true:
<#
powershell -c "(cat config.ps1) -replace ' = 0$',' = 1' | set-content config.ps1"
#>

[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
param()

$removePowershellISE = 0
$removeWordpad = 0
$removeOneDrive = 0

$removeAppxOfMsCloudApps = 0
$removeAppxOfXbox = 0

# Windows 11:

$noTaskbarWidgets = 0

if ($removeAppxOfMsCloudApps) {
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

if ($removeAppxOfXbox) {
    $removeAppxList += @"
Microsoft.Xbox.TCUI,
Microsoft.XboxApp,
Microsoft.XboxIdentityProvider,
Microsoft.XboxGameOverlay,
Microsoft.XboxGamingOverlay,
Microsoft.XboxSpeechToTextOverlay
"@
}