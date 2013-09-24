Clear-Host
Set-Location $PSScriptRoot

$lib_dir = Join-Path $(Split-Path -Parent $PSScriptRoot) 'lib'	
$pester_dir = Resolve-Path $(Join-Path $lib_dir 'Pester*\tools')

Import-Module $(Join-Path $pester_dir 'Pester.psm1')

Invoke-Pester #-relative_path Add-FileCache.Tests.ps1