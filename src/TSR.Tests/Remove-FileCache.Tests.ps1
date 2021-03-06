###
. "$(Join-Path $PSScriptRoot '_TestContext.ps1')"
###


Fixture "Remove-FileCache" {
	Mock Delete-File {}
	Mock Get-Content {} {$Path -eq '.\files.generated'}
	
	Given "that we don't want to clean the environment" {
		$_CleanEnvironment = $tsr.CleanEnvironment
		Set-Properties @{CleanEnvironment = $false}
		
		Then "we should not try to remove any files" {
			Remove-FileCache
			
			Assert-MockCalled Delete-File -Exactly 0
		}
		
		Set-Properties @{CleanEnvironment = $_CleanEnvironment}
	}
	
	Given "that there are no files to remove" {
		Mock Get-Content {return $null} {$Path -eq '.\files.generated'}
		
		Remove-FileCache
		
		Then "no files should be deleted" {
			Assert-MockCalled Delete-File -Exactly 0
		}
	}
	
	Given "that there are 3 files to remove" {
		Mock Get-Content {return "file1.txt;file2.txt;file3.txt"} {$Path -eq '.\files.generated'}
		
		Then "we should remove all of them" {
			Remove-FileCache
		
			Assert-MockCalled Delete-File -Exactly 3
		}
	}

}












