if ($cfg = $modules.tweak_registry) {
    $cfg.optimze = 1
    $cfg.protectMyPrivacy = 1
    $cfg.preferTouchpadGestures = 1

    $ex = $cfg.scripts.explorer
    $ex.optimize = 1
    $ex.useLibraries = 1
    $ex.showFileExtension = 1
    $ex.useRecylebinForUdisk = 1
    $ex.showRecentFolders = 1
    $ex.optimizePerformance = 1

    $d = $cfg.scripts.desktop
    $d.addUserFolder = 1
    $d.addLibrariesFolder = 1
    $d.addThisPC = 1
    $d.addNetworkInterfacesFolder = 1
    $d.addIconsCfgMenuItem = 1

    $tb = $cfg.scripts.taskbar
    $tb.optimize = 1
    $tb.biggerThumbnail = 1
    $tb.groupWhenOverflow = 1
    $tb.win10noPeople = 1
    $tb.win10noCortana = 1
    $tb.win10noSearchBar = 1
    $tb.win10oldVolumeMixer = 1
    $tb.win11alignLeft = 1
    $tb.win11showAllTray = 1
    $tb.win11noWidgets = 1
    $tb.win11noMsTeam = 1
}
