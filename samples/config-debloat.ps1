[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')] param()

$noTaskbarWidgets = 1

$removeCapabilityPowershellISE = 1
$removeCapabilityWordpad = 1
$removeCapabilityOneDrive = 1

$uninstallXbox = 1

Set-RemoveAppxList -BundledCloudApp -MediaPlayer -Communicater -Xbox
