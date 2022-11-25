. .\lib\loadModules.ps1
Import-Module ConfigLoader

.\lib\submitNewTaskbarLayout.ps1

if (Test-AuditMode) {
    & .\lib\submitNewUnattendFile.ps1
    if (!((Get-Process -ea 0 notepad).MainWindowTitle -join '').contains('unattend.xml')) {
        Start-Process -WindowStyle Minimized notepad.exe C:\Windows\Panther\unattend.xml
    }
}

.\lib\submitNewUserRegistry.ps1

Write-Output '', '==> FINISHED ALL!'

if (Test-AuditMode) {
    if (askInformationDialog 'win-sf' `
            @"
$(Get-Translation 'Repository: ' -cn '项目：')https://github.com/setupfw/win-sf
$(Get-Translation 'Author: ' -cn '作者：')LittleboyHarry
$(Get-Translation 'Status: OK' -cn '状态：已完成')
$(Get-Translation 'Blessing: have a nice day! ^_^' -cn '寄语：大吉大利，祝你鸿运当头！')

$(Get-Translation 'Confirm: start to SYSPREP.EXE now?' `
-cn '是否结束审核模式，封装系统以便使用？')
"@
    ) {
        Stop-Process -Name explorer
        & 'C:\Windows\System32\Sysprep\Sysprep.exe' /oobe /generalize /shutdown
        exit
    }
}

if (askQuestionDialog 'win-sf' (Get-Translation 'Restart File Explorer to finish?' -cn '重启文件资源管理器以生效？')) {
    Stop-Process -Name explorer
}

Pause
