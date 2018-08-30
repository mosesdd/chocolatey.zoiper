import-module au

$url                 = ''
$checksumTypePackage = "SHA512"

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1'   = @{
        #    "(^\s*[$]*urlPackage\s*=\s*)('.*')"          = "`$1'$($Latest.UrlPackage)'"
        #    "(^\s*[$]*checksumPackage\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum)'"
        #    "(^\s*[$]*checksumTypePackage\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType)'"
        }; 
    }
}

function global:au_GetLatest {

    $urlPackage = "https://www.zoiper.com/en/voip-softphone/download/zoiper5/for/windows"
  
    $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
    $cookie = New-Object System.Net.Cookie 
    $cookie.Name = "PHPSESSID"
    $cookie.Value = "chocolatey"
    $cookie.Domain = "www.zoiper.com"
    $session.Cookies.Add($cookie);

    $content = Invoke-WebRequest $urlPackage -WebSession $session
    
    
    $reLatestbuild = '(.*Zoiper.*)'
    $content.RawContent -imatch $reLatestbuild
    $latestbuild = $Matches[0]
    
    $reVersion = "(\d+)(.)(\d+)(.)(\d+)"
    $latestbuild -imatch $reVersion
    $version     = $Matches[0]
    
    Invoke-WebRequest $urlPackage -WebSession $session -OutFile "$($ENV:TMP)\Zoiper5_Installer_$($version).exe"
    Get-FileHash "$($ENV:TMP)\Zoiper5_Installer_$($version).exe" -Algorithm $checksumTypePackage

  #  return @{
  #      UrlPackage     = $urlPackage;
  #      Checksum       = $checksumPackage;
  #      ChecksumType   = $checksumTypePackage;
  #      Version        = $version
  #  }
}

function global:au_AfterUpdate ($Package) {
    Set-DescriptionFromReadme $Package -SkipFirst 3
}
update
