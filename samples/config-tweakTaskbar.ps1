if ($features.tweakTaskbar -eq 0) { $features.tweakTaskbar = [ordered]@{} }
$it = $features.tweakTaskbar

$it.optimize = 1
$it.biggerThumbnail = 1
$it.groupWhenOverflow = 1
$it.win10noSearchBar = 1
$it.win10oldVolumeMixer = 1
$it.win11alignLeft = 1
