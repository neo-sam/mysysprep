#Requires -RunAsAdministrator

if (!$isAuditMode) { exit }

if ($text = Get-Content '.\lib\assets\unattend.xml' -ea 0) {
    if ($unattend.oobeSkipEula) {
        $text = $text -replace '(?<=<HideEULAPage>).*?(?=</HideEULAPage>)', 'true'
    }
    if ($unattend.oobeSkipLoginMs) {
        $text = $text `
            -replace '(?<=<HideOnlineAccountScreens>).*(?=</)', 'true'`
            -replace '(?<=<HideWirelessSetupInOOBE>).*(?=</)', 'true'
    }
    if ($unattend.oobeSkipPrivacyOptions) {
        $text = $text -replace '(?<=<ProtectYourPC>).*(?=</)', '3'
    }

    if ($scriptText = Get-Content '.\lib\assets\firstrun.ps1' -ea 0) {
        $scriptText += "`n"
        foreach ($fnName in $unattend.firstrunFnList) {
            $scriptText += "$fnName`n"
        }
        $target = "$(mkdir -f C:\SetupFw)\firstrun.ps1"
        $scriptText > $target
        $text = $text -replace '(?=    </component>)', @"
      <FirstLogonCommands>
        <SynchronousCommand wcm:action="add">
          <Order>1</Order>
          <CommandLine>powershell -exec bypass -file $target</CommandLine>
          <Description>Initialization</Description>
        </SynchronousCommand>
      </FirstLogonCommands>

"@
    }

    $text | Out-File -Force -Encoding utf8 C:\Windows\Panther\unattend.xml
}
