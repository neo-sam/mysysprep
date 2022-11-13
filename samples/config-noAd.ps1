$features.disableAd = 1

if ($features.tweakTaskbar -eq 0) { $features.tweakTaskbar = [ordered]@{} }
$it = $features.tweakTaskbar

$it.win10noAd = 1
