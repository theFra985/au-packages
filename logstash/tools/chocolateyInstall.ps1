$ErrorActionPreference = 'Stop'

$PackageName = 'logstash'
$url32       = 'https://camunda.org/release/camunda-modeler/1.6.0/camunda-modeler-1.6.0-win32-ia32.zip'
$checksum32  = '1efb2e9e543e8da2938b14dfa5c41b417d62e7fee43f21d1d2bc1a8b706a48ae'

$packageArgs = @{
  packageName    = $packageName
  url            = $url32
  checksum       = $checksum32
  checksumType   = 'sha256'
  unzipLocation  = Split-Path $MyInvocation.MyCommand.Definition
}
Install-ChocolateyZipPackage @packageArgs