$features.addProfileToPwsh = 1
$features.enableSshAgent = 1

if ($features.tweakNewFileTypes -eq 0) {
    $features.tweakNewFileTypes = [ordered]@{}
}
$it = $features.tweakNewFileTypes
$it.addCmd = 1
$it.addMd = 1
$it.addPs1 = 1
$it.addIni = 1
$it.addReg = 1

$features.addGitKnownHosts = 1
