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

$features.customGitBash = 1
$features.customGitTig = 1
$features.customMintty = 1
$features.customPwshProfile = 1
$features.customSshKnownHosts = 1
$features.customVim = 1
