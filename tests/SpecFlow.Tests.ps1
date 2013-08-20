###
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$ctx = Join-Path $here  '_TestContext.ps1'
. $ctx
###

Describe "SpecFlow" {

	Context "when specflow.exe can't be found" {
		Begin-TestRun
		
		Get-ChildItem $cfg.PathToPackagesFolder -include "specflow.exe" -recurse | % {
			Remove-Item $_.FullName
		}
		
		It "should throw an error" {
			{ Get-SpecFlow } | Should Throw
		}
	
	}	

	Context "when specflow.exe already has a configuration file" {
		Begin-TestRun
		
		Setup -File 'Packages\SpecFlow-1.0.0\specflow.exe.config'
		
		It "should get information indicating that we already have a configuration file" {
			(Get-SpecFlow).HasConfigFile | Should Be True
		}
		
#		It "shouldn't overwrite the original specflow.exe configuration file" {
#			Mock Copy-SpecFlowConfigurationFile {}
#			
#			Invoke-SpecFlow "project-file"
#			Assert-MockCalled Copy-SpecFlowConfigurationFile -Times 0
#		}		
		
	}
			
	# TODO: we need a test for when there's a version like SpecFlow.1.9.0
	
}


