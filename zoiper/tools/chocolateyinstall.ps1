# zoiper install

$ErrorActionPreference = 'Stop';

$toolsDir            = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$PackageParameters   = Get-PackageParameters
$urlPackage          = 'https://www.zoiper.com/en/voip-softphone/download/zoiper5/for/windows'
$checksumPackage     = 'c9178db0b1d7e186b75bb059469c0e102725dff57779a6cd092b873200e414cc11b82ab924f739a61169facaefeef41d60113c054323d8f5359ed3035ce90aee'
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
