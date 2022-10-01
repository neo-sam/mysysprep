# Please edit below flags: set 0 to 1 meaning enable it

[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
param()

$oobeSkipEula = 0
$oobeSkipMsLogin = 0

# Disable User Data Collectors
$protectMyUserData = 0
$disableAd = 0

# Disable useless compatibility and error report
$disableUnusedServices = 0

$removeCapabilityPowershellISE = 0
$removeCapabilityWordpad = 0
$removeCapabilityOneDrive = 0

Set-RemoveAppxList # -BundledCloudApp -MediaPlayer -Communicater -Xbox

$uninstallXbox = 0

$optimzeExplorer = 1
$disableSshdServer = 1

# Windows 11:

$noTaskbarWidgets = 0
