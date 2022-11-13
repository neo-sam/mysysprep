#Requires -RunAsAdministrator

. .\lib\base.ps1
. .\lib\loadAllConfig.ps1

if ($null -eq ($text = Get-Content '.\lib\assets\unattend.xml' -ea 0)) { exit }

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

if (Test-Path ($target = "$(Get-BasePath)\scripts\firstrun.ps1")) {
  $text = $text -replace '(?<=    </OOBE>)', @"

      <FirstLogonCommands>
        <SynchronousCommand wcm:action="add">
          <Order>1</Order>
          <CommandLine>powershell -exec bypass -file `"$target`"</CommandLine>
          <Description>Initialization</Description>
        </SynchronousCommand>
      </FirstLogonCommands>
"@
}

$text | Out-File -Force -Encoding utf8 C:\Windows\Panther\unattend.xml
