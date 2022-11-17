. .\lib\loadAllConfig.ps1

$basepath = 'C:\Program Files\win-sf'

if ($null -eq ($text = Get-Content '.\lib\assets\unattend.xml' -ea 0)) { exit }

$osv = [System.Environment]::OSVersion.Version.Build

# $text = $text -replace 'processorArchitecture="amd64"', 'processorArchitecture="arm64"'

function Add-OobeItem([string]$key, [string]$value) {
  $Script:text = $text -replace '(?=      </OOBE>)', @"
        <$key>$value</$key>

"@
}

if ($unattend.oobeSkipEula) {
  Add-OobeItem HideEULAPage true
}

if ($unattend.oobeSkipPrivacyOptions) {
  Add-OobeItem ProtectYourPC 3
}

if ($osv -gt 7601) {
  if ($unattend.oobeSkipLoginMs) {
    Add-OobeItem HideOnlineAccountScreens true
    Add-OobeItem HideWirelessSetupInOOBE true
  }
}

if (Test-Path ($target = "$basepath\scripts\firstrun.ps1")) {
  $text = $text -replace '(?<=    </OOBE>)', @"

      <FirstLogonCommands>
        <SynchronousCommand wcm:action="add">
          <Order>1</Order>
          <CommandLine>cmd.exe /c C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -exec bypass -file `"$target`"</CommandLine>
          <Description>Initialization</Description>
        </SynchronousCommand>
      </FirstLogonCommands>
"@
}

return $text
