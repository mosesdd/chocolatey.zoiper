# zoiper install

$ErrorActionPreference = 'Stop';

$toolsDir            = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$PackageParameters   = Get-PackageParameters
$urlPackage          = 'https://www.zoiper.com/en/voip-softphone/download/zoiper5/for/windows'
$checksumPackage     = '488fec98a7f1da4728c19d8d68ad269d2dcefdd89df95d9a6fba616f4538ccd0cf65c6f52a57879bd6ee0dc9941132d787b9af41ebfe95e735f550bba3826956'
$checksumTypePackage = 'SHA512'

Import-Module -Name "$($toolsDir)\helpers.ps1"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'EXE'
  url            = $urlPackage
  checksum       = $checksumPackage
  checksumType   = $checksumTypePackage
  silentArgs     = '--mode unattended --unattendedmodeui none'
  options        = @{Headers = @{Cookie = "PHPSESSID = Chocolatey";}}
}

Install-ChocolateyPackage @packageArgs

if ($PackageParameters.RemoveDesktopIcons) {
    Remove-DesktopIcons -Name "Zoiper5" -Desktop "Public"
}

if ($PackageParameters.CleanStartmenu) {
	Remove-FileItem `
		-Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Zoiper5"
  Install-ChocolateyShortcut `
    -ShortcutFilePath "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Zoiper.lnk" `
    -TargetPath "C:\Program Files (x86)\Zoiper5\Zoiper5.exe" `
    -WorkDirectory "C:\Program Files (x86)\Zoiper5"
}
