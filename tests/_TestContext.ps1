$here = Split-Path -Parent $MyInvocation.MyCommand.Definition
$src = Join-Path (Split-Path -Parent $here) 'src'
$functions = Join-Path $src 'functions'
$script = Join-Path $src 'TeamCity.SpecFlow.Reporting.psm1'

if(Get-Module TeamCity.SpecFlow.Reporting){
	Remove-Module TeamCity.SpecFlow.Reporting
}
Import-Module $script

$sut = Join-Path $functions (Split-Path -Leaf $MyInvocation.ScriptName).Replace(".Tests.", ".")
. $sut


function Begin-TestRun {
	Setup -File 'Packages\SpecFlow.1.0.0\specflow.exe'

	Set-Properties @{
		PathToPackagesFolder = 'TestDrive:\'
		Verbose = $false
	}
}




