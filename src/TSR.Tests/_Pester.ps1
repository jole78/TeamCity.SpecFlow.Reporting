Clear-Host
Set-Location $PSScriptRoot

$root_dir = Split-Path -Parent $PSScriptRoot | Split-Path -Parent
$lib_dir = Join-Path $root_dir 'lib'	
$pester_dir = Resolve-Path $(Join-Path $lib_dir 'Pester*\tools')

Import-Module $(Join-Path $pester_dir 'Pester.psm1')

Invoke-Pester #-relative_path Add-FileCache.Tests.ps1