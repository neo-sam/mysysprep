$features.debloatOneDrive = 1
$features.tweakStartmenu = @{
    disableWebSearch  = 1
    disableFileSearch = 1
}

$features.applyClassicPhotoViewer = 1
$features.debloatNewPhotoViewer = 1

if (Test-Path '.\deploy\Thunderbird Setup *.exe') {
    $features.debloatNewEmailAndCalendar = 1
}

if (Test-Path '.\deploy\vlc-*-win64.exe') {
    $features.debloatNewMediaPlayer = 1
}

if ($features.tweakTaskbar -eq 0) { $features.tweakTaskbar = [ordered]@{} }
$it = $features.tweakTaskbar

$it.win10noPeople = 1
$it.win10noCortana = 1
$it.win11noWidgets = 1
$it.win11noMsTeam = 1
