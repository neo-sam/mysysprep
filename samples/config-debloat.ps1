if ($cfg = $debloatModuleCfg) {
    $cfg.oneDrive = 1
    $cfg.collectors = @{
        privacy  = 1
        services = 1
        xbox     = 1
    }
    $cfg.capabilities = @{
        powershellIse = 1
        wordpad       = 1
    }
    $cfg.provisionAppx = @{
        cloudApps        = 1
        zuneMediaPlayer  = 1
        xbox             = 1
        emailAndCalendar = 1
        photo            = 1
    }
}
