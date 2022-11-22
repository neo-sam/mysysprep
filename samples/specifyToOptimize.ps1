$features.applyOptimization = 1
$features.applyRemapIcon = 1
$features.enableClipboardHistory = 1
$features.fixHidpiBlur = 1

$features.addUserFirstRun = [ordered]@{
    addDesktopIconConfigMenuItem           = 1
    showUserProfileIcon                    = 1
    showLibrariesIcon                      = 1
    showThisPcIcon                         = 1
    showInterfacesIconAtDesktop            = 1
    showRecyleBinIconAtExplorerSidebar     = 1
    showRecentFoldersIconAtExplorerSidebar = 1
}

if ($features.tweakContextmenu -eq 0) { $features.tweakContextmenu = [ordered]@{} }
$it = $features.tweakContextmenu

$it.hideCompatibilityHelper = 1

if ($features.tweakNewFileTypes -eq 0) {
    $features.tweakNewFileTypes = [ordered]@{}
}
$it = $features.tweakNewFileTypes
$it.removeBmp = 1
$it.removeRtf = 1
# Windows 7:
$it.removeJnt = 1
$it.removeContact = 1

if ($features.tweakSendTo -eq 0) {
    $features.tweakSendTo = [ordered]@{}
}
$features.tweakSendTo.optimize = 1
$features.tweakSendTo.addStartMenu = 1
