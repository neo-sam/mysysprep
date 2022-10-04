
param(
    $cloudApps,
    $zuneMediaPlayer,
    $xbox,
    $emailAndCalendar,
    $photo
)

$removeAppxList = ''

if ($cloudApps) {
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

if ($zuneMediaPlayer) {
    $removeAppxList += @"
Microsoft.ZuneMusic
Microsoft.ZuneVideo
"@
}

if ($emailAndCalendar) {
    $removeAppxList += @"
microsoft.windowscommunicationsapps
"@
}

if ($xbox) {
    $removeAppxList += @"
Microsoft.Xbox.TCUI
Microsoft.XboxApp
Microsoft.XboxIdentityProvider
Microsoft.XboxGameOverlay
Microsoft.XboxGamingOverlay
Microsoft.XboxSpeechToTextOverlay
"@
}

if ($photo) {
    $removeAppxList += @"
Microsoft.Windows.Photos
"@
}

foreach ($name in "$removeAppxList".Split("`n")) {
    if ($name -eq '') { continue }
    $app = Get-AppxPackage -Name $name
    if ($null -ne $app) {
        $app | Remove-AppxPackage
        logif1 "Remove-AppxPackage $name [ok]"
    }
    $papp = Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $name
    if ($null -ne $app) {
        $papp | Remove-AppxProvisionedPackage -Online | Out-Null
        logif1 "Remove-AppxProvisionedPackage $name [ok]"
    }
}
