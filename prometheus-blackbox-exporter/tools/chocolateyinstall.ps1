﻿$ErrorActionPreference = 'Stop'

$PackageName = 'prometheus-blackbox-exporter'
$url32       = 'https://github.com/prometheus/blackbox_exporter/releases/download/v0.10.0/blackbox_exporter-0.10.0.windows-386.tar.gz'
$url64       = 'https://github.com/prometheus/blackbox_exporter/releases/download/v0.10.0/blackbox_exporter-0.10.0.windows-amd64.tar.gz'
$checksum32  = 'da5052f5c856859b056e2b4bbaa02c3462630ade7e9c559c74b70ca68d015000'
$checksum64  = 'c0d24e5cd1b7e69e4fd0e2f70a6804d9aa661e55dc3832e3a3391c0a2e20881c'

$packageArgs = @{
  packageName    = $packageName
  url            = $url32
  url64Bit       = $url64
  checksum       = $checksum32
  checksum64     = $checksum64
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  unzipLocation  = Split-Path $MyInvocation.MyCommand.Definition
}
Install-ChocolateyZipPackage @packageArgs
$File = Get-ChildItem -File -Path $env:ChocolateyInstall\lib\$packageName\tools\ -Filter *.tar
Get-ChocolateyUnzip -fileFullPath $File.FullName -destination $env:ChocolateyInstall\lib\$packageName\tools\

$ServiceName = 'prometheus-blackbox-exporter'

Write-Host "Installing service"

if ($Service = Get-Service $ServiceName -ErrorAction SilentlyContinue) {
    if ($Service.Status -eq "Running") {
        Start-ChocolateyProcessAsAdmin "stop $ServiceName" "sc.exe"
    }
    Start-ChocolateyProcessAsAdmin "delete $ServiceName" "sc.exe"
}

$ExporterExe = Get-ChildItem -File -Path $(Join-Path $File.DirectoryName $File.basename) -Filter *.exe
Start-ChocolateyProcessAsAdmin "install $ServiceName $($ExporterExe.FullName)" nssm
Start-ChocolateyProcessAsAdmin "set $ServiceName Start SERVICE_DEMAND_START" nssm
