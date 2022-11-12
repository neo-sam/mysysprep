# Please edit below flags: set 0 to 1 meaning enable it

$Script:features = @{
    addDocument                 = 0
    addPwshProfile              = 0
    addNewIsolatedUserScript    = 0
    addQuickSettings          = 0
    addVscode                   = 0

    applyPrivacyProctection     = 0
    applyOptimization           = 0
    applyBetterTouchpadGestures = 0
    applyClassicPhotoViewer     = 0
    applyRemapIcon              = 0

    debloatOneDrive             = 0
    debloatCloudapps            = 0
    debloatXbox                 = 0
    debloatNewEmailAndCalendar  = 0
    debloatNewMediaPlayer       = 0
    debloatNewPhotoViewer       = 0

    disableAd                   = 0

    enableClipboardHistory      = 0

    fixHidpiBlur                = 0

    tweakExplorer               = @{
        showFileExtension    = 0
        useRecylebinForUdisk = 0
        optimizePerformance  = 0
        optimize             = 0
    }
    tweakContextmenu            = @{
        hideCompatibilityHelper = 0
    }
    tweakTaskbar                = @{
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
    tweakIme                    = @{
        candidates     = 0
        biggerFontSize = 0
    }
    tweakStartmenu              = @{
        disableWebSearch  = 0
        disableFileSearch = 0
    }

}

$Script:deploy = @{}

$Script:unattend = @{
    oobeSkipEula           = 0
    oobeSkipLoginMs        = 0
    oobeSkipPrivacyOptions = 0
    firstrunFnList         = @()
}
