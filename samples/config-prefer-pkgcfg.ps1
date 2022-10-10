
if ($modules) {
    if ($modules.deploy_pkgs) {
        $modules.deploy_pkgs.useWorkraveConfig = 1
        $modules.deploy_pkgs.disableOpensshServer = 1
    }
}
