###
. "$(Join-Path $PSScriptRoot '_TestContext.ps1')"
###

Fixture "Get-FirstOrDefault" {
	
	Given "the item we're looking for doesn't exist" {
		$actual = Get-FirstOrDefault "C:\DoesNotExists"
		
		Then "it should return the default value" {
			$actual | Should Be $null
		}
	}
	
	Given "we have found more than one item that matches" {
		Setup -File "somefile.txt"
		Setup -File "someotherfile.txt"
		
		$actual = Get-FirstOrDefault $(Join-Path $TestDrive "some*.txt")
		
		Then "it should only return the first value" {
			$actual.Count | Should Be 1
		}
	}
}










