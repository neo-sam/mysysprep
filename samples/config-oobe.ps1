if ($cfg = $sysprepCfg) {
    $cfg.oobe = @{
        skipEula    = 1
        skipMsLogin = 1
    }
}
