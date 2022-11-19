if ($features.tweakTaskbar -eq 0) { $features.tweakTaskbar = [ordered]@{} }
$it = $features.tweakTaskbar

$it.optimize = 1
$it.biggerThumbnail = 1
$it.groupWhenOverflow = 1
$it.w11setAlignLeft = 1
$it.w10setSearchBarIconOnly = 1
$it.w10setVolumeMixerClassic = 1
