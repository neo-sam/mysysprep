. '.\lib\require-admin.ps1'

. '.\lib\load-commonfn.ps1'
. '.\lib\load-env-with-cfg.ps1'

$cfg = $modules.desktop

if ($null -ne $PSScriptRoot) {
    $script:PSScriptRoot = Split-Path $script:MyInvocation.MyCommand.Path -Parent
}
$template = "$PSScriptRoot\template"
$defaultDesktop = 'C:\Users\Default\Desktop'

if ($cfg.addVscodeGetter) {
    $scriptPath = 'C:\Users\Public\get-vscode.ps1'

    $text = Get-Content "$template\get-vscode.ps1"
    $lnkname = "$(Get-Translation 'Get' -cn '获取') VSCode"
    New-SetupScriptShortcut -psspath $scriptPath -lnkname $lnkname

    if ((Get-Culture).Name -eq "zh-CN") {
        $text = $text -replace '(?<=\$rewriteUrl = ).+', '"https://vscode.cdn.azure.cn$path"'
    }
    if ($cfg.addDevbookLinks) {
        $url = switch ((Get-Culture).Name) {
            zh-CN { 'https://devbook.littleboyharry.me/zh-CN/docs/devenv/vscode/settings' }
            Default { 'https://devbook.littleboyharry.me/docs/devenv/vscode/settings' }
        }
        $text += "start '$url'`n"
    }
    $text += "rm -fo `"`$([Environment]::GetFolderPath('Desktop'))\$lnkname.lnk`"`n"
    $text | Out-File -Force $scriptPath
}

if ($cfg.addDevbookLinks) {
    function New-DevbookShortcut {
        param([string]$name, [string]$path)

        $prefix = Get-Translation Config -cn 配置
        $shortcut = "$([Environment]::GetFolderPath('Desktop'))\$prefix $name.url"

        if (!(Test-Path $shortcut)) {
            $it = (New-Object -ComObject WScript.Shell).CreateShortcut($shortcut)
            $it.TargetPath = switch ((Get-WinSystemLocale).Name) {
                zh-CN { "https://devbook.littleboyharry.me/zh-CN/$path" }
                Default { "https://devbook.littleboyharry.me/$path" }
            }
            $it.Save()
        }
        if ($isAdmin) {
            Copy-Item -Force $shortcut $defaultDesktop
        }
    }

    New-DevbookShortcut 'Windows' 'docs/setup-mswin/firstrun'
    New-DevbookShortcut 'Store Apps' 'docs/setup-mswin/personalize/apps-from-store'
    New-DevbookShortcut (
        Get-Translation 'Input & Keymap' -cn '输入法与键盘'
    ) 'docs/setup-mswin/tweak/input'

    if (Test-Path 'C:\Program Files\Mozilla Firefox\firefox.exe') {
        New-DevbookShortcut Firefox docs/goodsoft/firefox/setup
    }
    if (Test-Path "C:\Program Files (x86)\Vim\vim*\vim.exe") {
        New-DevbookShortcut gVim docs/devenv/vim
    }
    if ($modules.deploy.installWsl2) {
        New-DevbookShortcut WSL2 docs/setup-mswin/devenv/wsl2
    }
}

Copy-Item -Force (Get-Translation "$template\README.md" -cn "$template\README-CN.md") `
    "$defaultDesktop\$(Get-Translation 'README.txt' -cn '注意事项.txt')"
