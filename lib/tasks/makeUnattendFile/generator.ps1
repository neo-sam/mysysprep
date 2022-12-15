. "$PSScriptRoot\..\..\modules\common\import.ps1"

$template = Get-Content -ea 0 -Raw "$PSScriptRoot\unattend.xml"

function Add-OobeItem([string]$text, [string]$key, [string]$value) {
  return $text -replace '(?=      </OOBE>)', @"
        <$key>$value</$key>

"@
}

if ($null -eq $template) { throw 'No Unattend Template File!' }

$result = $template

if (Test-CpuArchIsArm64) {
  $result = $result -replace 'processorArchitecture="amd64"', 'processorArchitecture="arm64"'
}

if (Get-UnattendConfig skipOobeEula) {
  $result = Add-OobeItem $result HideEULAPage true
}

if (Get-UnattendConfig skipOobePrivacyOptions) {
  $result = Add-OobeItem $result ProtectYourPC 3
}

if ((Get-OSVersionBuild) -gt 7601) {
  if (Get-UnattendConfig skipOobeMsLogin) {
    $result = Add-OobeItem $result HideOnlineAccountScreens true
    $result = Add-OobeItem $result HideWirelessSetupInOOBE true
  }
}

if (Test-Path ($target = "$(Get-AppFolderPath)\scripts\firstrun.ps1")) {
  $result = $result -replace '(?<=    </OOBE>)', @"

        <FirstLogonCommands>
          <SynchronousCommand wcm:action="add">
            <Order>1</Order>
            <CommandLine>cmd.exe /c C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -exec bypass -file `"$target`"</CommandLine>
            <Description>Initialization</Description>
          </SynchronousCommand>
        </FirstLogonCommands>
"@
}
return $result
