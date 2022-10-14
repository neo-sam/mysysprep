if ($modules.debloat) {
    $modules.debloat = @{
        one_drive     = 1
        collectors    = @{
            privacy  = 1
            services = 1
            xbox     = 1
        }
        capabilities  = @{
            wordpad = 1
        }
        provisionAppx = @{
            cloudApps        = 1
            zuneMediaPlayer  = 1
            emailAndCalendar = 1
            xbox             = 1
            photo            = 1
        }
    }
}

if ($cfg = $modules.tweak_registry) {
    $tb = $cfg.scripts.taskbar
    $tb.win10noPeople = 1
    $tb.win10noCortana = 1
    $tb.win10noSearchBar = 1
    $tb.win11noWidgets = 1
    $tb.win11noMsTeam = 1
}
