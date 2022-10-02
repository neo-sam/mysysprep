if ($cfg = $registryCfg) {
    $cfg.protectMyPrivacy = 1
    $cfg.disableAd = 1

    $expl = $cfg.explorer
    $expl.optimize = 1
    $expl.useLibraries = 1

    $cfg.taskbar = @{
        optimize            = 1
        biggerThumbnail     = 1
        groupWhenOverflow   = 1
        win10noAd           = 1
        win10noPeople       = 1
        win10noCortana      = 1
        win10noSearch       = 1
        win10oldVolumeMixer = 1
        win11noWidgets      = 1
        win11alignLeft      = 1
        win11noMsTeam       = 1
    }

    $cfg.remap_icons = 1
}
