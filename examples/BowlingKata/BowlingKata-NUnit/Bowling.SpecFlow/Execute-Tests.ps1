Set-Location $PSScriptRoot

Import-Module .\TeamCity.SpecFlow.Reporting.psm1

Set-Properties @{
    PathToPackagesFolder = '..\..\'
}

Invoke-TeamCitySpecFlowReport