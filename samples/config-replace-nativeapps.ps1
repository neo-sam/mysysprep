$it = $features

if (Test-Path '.\deploy\Thunderbird Setup *.exe') {
    $features.debloatNewEmailAndCalendar = 1
}

if (Test-Path '.\deploy\vlc-*-win64.exe') {
    $it.debloatNewMediaPlayer = 1
}

$it.useClassicPhotoViewer = 1
$it.debloatNewPhotoViewer = 1
