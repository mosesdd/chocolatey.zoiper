﻿# zoiper install

$ErrorActionPreference = 'Stop';

$toolsDir            = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$PackageParameters   = Get-PackageParameters
$urlPackage          = 'https://www.zoiper.com/en/voip-softphone/download/zoiper5/for/windows'
$checksumPackage     = 'd60c4bdf87d2bb494570b1c7c5980bf57fcddd518f9a71379d578674983c02c65d97ffd44a80bcf0f4944e00a60591304c36d72990856d6aab39ac957124d340'
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
