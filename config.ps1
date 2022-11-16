# Please edit below flags: set 0 to 1 meaning enable it

$Script:features = [ordered]@{
    addDocuments                 = 0
    addNewIsolatedUserScript    = 0
    addProfileToPwsh            = 0
    addQuickSettings            = 0

    applyBetterTouchpadGestures = 0
    applyClassicPhotoViewer     = 0
    applyOptimization           = 0
    applyPrivacyProctection     = 0
    applyRemapIcon              = 0

    debloatOneDrive             = 0
    debloatCloudapps            = 0
    debloatXbox                 = 0
    debloatNewEmailAndCalendar  = 0
    debloatNewMediaPlayer       = 0
    debloatNewPhotoViewer       = 0

    disableAd                   = 0

    enableClipboardHistory      = 0
    enableSshAgent              = 0

    fixHidpiBlur                = 0

    addUserFirstRun             = 0

    tweakContextmenu            = 0
    tweakExplorer               = 0
    tweakIme                    = 0
    tweakNewFileTypes           = 0
    tweakStartmenu              = 0
    tweakTaskbar                = 0
}

$Script:it = $null

if ($features.addUserFirstRun -ne 0) {
    $features.addUserFirstRun = [ordered]@{
        addDesktopIconConfigMenuItem           = 0
        showUserProfileIcon                    = 0
        showLibrariesIcon                      = 0
        showThisPcIcon                         = 0
        showInterfacesIconAtDesktop            = 0
        showRecyleBinIconAtExplorerSidebar     = 0
        showRecentFoldersIconAtExplorerSidebar = 0
    }
}

if ($features.tweakContextmenu -ne 0) {
    $features.tweakContextmenu = @{
        hideCompatibilityHelper = 0
    }
}

if ($features.tweakExplorer -ne 0) {
    $features.tweakExplorer = @{
        showFileExtension    = 0
        useRecylebinForUdisk = 0
        optimizePerformance  = 0
        optimize             = 0
    }
}

if ($features.tweakIme -ne 0) {
    $features.tweakIme = @{
        candidates     = 0
        biggerFontSize = 0
    }
}

if ($features.tweakNewFileTypes -ne 0) {
    $features.tweakNewFileTypes = [ordered]@{
        addCmd        = 0
        addMd         = 0
        addPs1        = 0
        addIni        = 0
        addReg        = 0
        removeBmp     = 0
        removeRtf     = 0
        # Windows 7:
        removeContact = 0
        removeJnt     = 0
    }
}

if ($features.tweakStartmenu -ne 0) {
    $features.tweakStartmenu = @{
        disableWebSearch  = 0
        disableFileSearch = 0
    }
}

if ($features.tweakTaskbar -ne 0) {
    $features.tweakTaskbar = @{
        optimize            = 0
        biggerThumbnail     = 0
        groupWhenOverflow   = 0
        win10noAd           = 0
        win10noPeople       = 0
        win10noCortana      = 0
        win10noSearchBar    = 0
        win10oldVolumeMixer = 0
        win11alignLeft      = 0
        win11noWidgets      = 0
        win11noMsTeam       = 0
    }
}

$Script:skipDeploy = 0

$Script:unattend = [ordered]@{
    oobeSkipEula           = 0
    oobeSkipLoginMs        = 0
    oobeSkipPrivacyOptions = 0
}
