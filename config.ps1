# Please edit below flags: set 0 to 1 meaning enable it

[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
param()

if ($cfg = $sysprepCfg) {
    $cfg.oobe = @{
        skipEula    = 0
        skipMsLogin = 0
    }
}

if ($cfg = $registryCfg) {
    $cfg.protectMyPrivacy = 0
    $cfg.disableAd = 0
    $cfg.explorer = @{
        optimize     = 0
        useLibraries = 0
    }
    $cfg.taskbar = @{
        disableWin11Widgets = 0
    }
    $cfg.contextmenu = @{
        disableWin11NewStyle = 0
    }
    $cfg.remap_icons = 0
}

if ($cfg = $debloatModuleCfg) {
    $cfg.oneDrive = 0
    $cfg.collectors = @{
        privacy  = 0
        services = 0
        xbox     = 0
    }
    $cfg.capabilities = @{
        powershellIse = 0
        wordpad       = 0
    }
    $cfg.provisionAppx = @{
        cloudApps        = 0
        zuneMediaPlayer  = 0
        emailAndCalendar = 0
        xbox             = 0
        photo            = 0
    }
}

if ($cfg = $pkgsCfg) {
    $cfg.disableOpensshServer = 0
}
