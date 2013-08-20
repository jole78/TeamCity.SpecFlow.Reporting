###
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$ctx = Join-Path $here  '_TestContext.ps1'
. $ctx
###

Describe "Get-PackagesFolder" {
	
	Context "when the 'packages' folder can't be found" {
		Begin-TestRun
		
	    It "should throw an error" {
	        { Get-PackagesFolder 'Invalid Path' } | Should Throw
	    }
		
	}

}

Describe "Get-Package" {
	
	Context "when the package doesn't exist" {
		Begin-TestRun
		
		It "should throw an error" {
			{ Get-Package 'Invalid Package' } | Should Throw
		}
	}
	
	Context "when there's multiple versions of the same package" {
		Begin-TestRun
		
		Setup -Dir 'Packages\SpecFlow.1.0.0'
		Setup -Dir 'Packages\SpecFlow.1.0.1'
		
		$result = Get-Package "SpecFlow"
		
		It "should return latest version" {
			$result.Version | Should Be "1.0.1"
		}
		
	}

}

