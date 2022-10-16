# Please edit below flags: set 0 to 1 meaning enable it

[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
param()

$modules = @{
    debloat  = @{
        one_drive     = 0
        collectors    = @{
            privacy  = 0
            services = 0
            xbox     = 0
        }
        capabilities  = @{
            wordpad = 0
        }
        provisionAppx = @{
            cloudApps        = 0
            zuneMediaPlayer  = 0
            emailAndCalendar = 0
            xbox             = 0
            photo            = 0
        }
    }
    deploy   = @{
        useWorkraveConfig    = 0
        disableOpensshServer = 0
        installWsl2          = 0
    }
    registry = @{
        optimze                  = 0
        protectMyPrivacy         = 0
        disableAd                = 0
        advancedRemapIcons       = 0
        preferTouchpadGestures   = 0
        enableClassicPhotoViewer = 0
        components               = @{
            desktop   = @{
                addUserFolder              = 0
                addLibrariesFolder         = 0
                addThisPC                  = 0
                addNetworkInterfacesFolder = 0
                addIconsCfgMenuItem        = 0
            }
            explorer  = @{
                showFileExtension    = 0
                showRecentFolders    = 0
                useRecylebinForUdisk = 0
                optimizePerformance  = 0
                optimize             = 0
            }
            startmenu = @{
                disableWebSearch  = 0
                disableFileSearch = 0
            }
            taskbar   = @{
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
            ime       = @{
                candidates     = 0
                biggerFontSize = 0
            }
        }
    }
    desktop  = @{
        addDevbookLinks = 0
        addVscodeGetter = 0
    }
}

$sysprep = @{
    oobeSkipEula    = 0
    oobeSkipLoginMs = 0
}
