function Set-RemoveAppxList {
    param(
        [switch]$BundledCloudApp,
        [switch]$MediaPlayer,
        [switch]$Communicater,
        [switch]$Xbox
    )

    if ($BundledCloudApp) {
        $script:removeAppxList += @"
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
    if ($MediaPlayer) {
        $script:removeAppxList += @"
Microsoft.ZuneMusic
Microsoft.ZuneVideo
"@
    }
    if ($Communicater) {
        $script:removeAppxList += @"
microsoft.windowscommunicationsapps
"@
    }
    if ($Xbox) {
        $script:removeAppxList += @"
Microsoft.Xbox.TCUI
Microsoft.XboxApp
Microsoft.XboxIdentityProvider
Microsoft.XboxGameOverlay
Microsoft.XboxGamingOverlay
Microsoft.XboxSpeechToTextOverlay
"@
    }
}
