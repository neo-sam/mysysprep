$it = $modules.registry
$it.optimze = 1
$it.protectMyPrivacy = 1
$it.preferTouchpadGestures = 1

$ex = $it.components.explorer
$ex.optimize = 1
$ex.showFileExtension = 1
$ex.useRecylebinForUdisk = 1
$ex.showRecentFolders = 1
$ex.optimizePerformance = 1

$d = $it.components.desktop
$d.addUserFolder = 1
$d.addLibrariesFolder = 1
$d.addThisPC = 1
$d.addNetworkInterfacesFolder = 1
$d.addIconsCfgMenuItem = 1

$tb = $it.components.taskbar
$tb.optimize = 1
$tb.biggerThumbnail = 1
$tb.groupWhenOverflow = 1
$tb.win10noPeople = 1
$tb.win10noCortana = 1
$tb.win10noSearchBar = 1
$tb.win10oldVolumeMixer = 1
$tb.win11alignLeft = 1
$tb.win11noWidgets = 1
$tb.win11noMsTeam = 1

$sysprep.firstrun = @(
    'showUserFolderAtDesktop'
    'showLibrariesAtDesktop'
    'showThisPcAtDesktop'
    'showNetworkInterfacesAtDesktop'
    'addDesktopIconConfigMenuItem'
    'showRecentFoldersInExplorerSidebar'
)
