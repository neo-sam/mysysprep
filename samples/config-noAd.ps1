$features.disableAd = 1

if ($features.tweakTaskbar -eq 0) { $features.tweakTaskbar = [ordered]@{} }
$it = $features.tweakTaskbar

$it.w10noAd = 1
