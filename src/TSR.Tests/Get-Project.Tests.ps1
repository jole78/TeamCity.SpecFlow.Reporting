###
. "$(Join-Path $PSScriptRoot '_TestContext.ps1')"
###


Fixture "Get-Project" {
	
	Given "the project file is missing" {
		
		Remove-Item $ProjectFileName	
			
		Then "it should display an error" {
			Get-Project -ea SilentlyContinue -ev actual
			
			$actual | Should Not BeNullOrEmpty
		}		
	}

}









