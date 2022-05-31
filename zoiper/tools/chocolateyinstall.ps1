# zoiper install

$ErrorActionPreference = 'Stop';

$toolsDir            = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$PackageParameters   = Get-PackageParameters
$urlPackage          = 'https://www.zoiper.com/en/voip-softphone/download/zoiper5/for/windows'
$checksumPackage     = '36C1AC57293D880087A79EE142091278BE29C4557B3F46EF0C1C13ECA1B472068AF39FC030645E7E6010C7AB369D7C76EB57BD7A6A142CF73D99438F2B87FB9B'
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
