if ($cfg = $modules.tweak_registry) {
    $cfg.enableClassicPhotoViewer = 1
    if ($cfgSm = $cfg.scripts.startmenu) {
        $cfgSm.disableWebSearch = 1
        $cfgSm.disableFileSearch = 1
    }
    $cfg.advancedRemapIcons = 1
}
