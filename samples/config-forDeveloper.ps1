$features.addProfileToPwsh = 1
$features.enableSshAgent = 1

if ($features.tweakNewFileTypes -eq 0) {
    $features.tweakNewFileTypes = @{}
}
$it = $features.tweakNewFileTypes
$it.addCmd = 1
$it.addMd = 1
$it.addPs1 = 1
