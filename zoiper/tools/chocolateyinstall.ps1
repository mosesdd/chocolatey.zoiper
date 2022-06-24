# zoiper install

$ErrorActionPreference = 'Stop';

$toolsDir            = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$PackageParameters   = Get-PackageParameters
$urlPackage          = 'https://www.zoiper.com/en/voip-softphone/download/zoiper5/for/windows'
$checksumPackage     = 'bb2503e7b4d3d6b7bdea886012eedac3a386b28995c72acfb0cece6e0cac1b8f0e6593aa4867565f41c63cf4a4950aca347c43c9f00c4b61eb239fc1b8865ee4'
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
