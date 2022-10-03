# Please edit below flags: set 0 to 1 meaning enable it

[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
param()

if ($modules.debloat) {
    $modules.debloat = @{
        one_drive     = 0
        collectors    = @{
            privacy  = 0
            services = 0
            xbox     = 0
        }
        capabilities  = @{
            powershell_ise = 0
            wordpad        = 0
        }
        provisionAppx = @{
            cloudApps        = 0
            zuneMediaPlayer  = 0
            emailAndCalendar = 0
            xbox             = 0
            photo            = 0
        }
    }
}

if ($modules.deploy_pkgs) {
    $modules.deploy_pkgs = @{
        useWorkraveConfig    = 0
        useAltsnapConfig     = 0
        disableOpensshServer = 0
    }
}

if ($modules.tweak_registry) {
    $modules.tweak_registry = @{
        optimze            = 0
        protectMyPrivacy         = 0
        disableAd                = 0
        advancedRemapIcons       = 0
        enableClassicPhotoViewer = 0
        subscripts               = @{
            explorer    = @{
                showFileExtension    = 0
                showRecentFolders    = 0
                useLibraries         = 0
                useRecylebinForUdisk = 0
                optimizePerformance  = 0
                optimize             = 0
            }
            contextmenu = @{
                disableWin11NewStyle = 0
            }
            startmenu   = @{
                disableWebSearch  = 0
                disableFileSearch = 0
            }
            taskbar     = @{
                optimize            = 0
                biggerThumbnail     = 0
                groupWhenOverflow   = 0
                win10noAd           = 0
                win10noPeople       = 0
                win10noCortana      = 0
                win10noSearchBar    = 0
                win10oldVolumeMixer = 0
                win11noWidgets      = 0
                win11alignLeft      = 0
                win11noMsTeam       = 0
            }
        }
    }
}

if ($sysprep) {
    $sysprep = @{
        oobeSkipEula    = 0
        oobeSkipLoginMs = 0
    }
}
