$features.debloatOneDrive = 1
$features.tweakStartmenu = @{
    disableWebSearch  = 1
    disableFileSearch = 1
}

$features.applyClassicPhotoViewer = 1
$features.debloatNewPhotoViewer = 1

if (Test-Path '.\packages\Thunderbird Setup *.exe') {
    $features.debloatNewEmailAndCalendar = 1
}

if (Test-Path '.\packages\vlc-*-win64.exe') {
    $features.debloatNewMediaPlayer = 1
}

if ($features.tweakTaskbar -eq 0) { $features.tweakTaskbar = [ordered]@{} }
$it = $features.tweakTaskbar

$it.w10noContactIcon = 1
$it.w10noCortanaIcon = 1
$it.w11noWidgets = 1
$it.w11noMsTeamIcon = 1
