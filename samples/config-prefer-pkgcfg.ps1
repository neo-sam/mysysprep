
if ($modules) {
    if ($modules.deploy_pkgs) {
        $modules.deploy_pkgs = @{
            useWorkraveConfig    = 1
            useAltsnapConfig     = 1
            disableOpensshServer = 1
        }
    }
}
