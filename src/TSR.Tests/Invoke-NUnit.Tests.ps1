###
. "$(Join-Path $PSScriptRoot '_TestContext.ps1')"
###

function Background {
	Mock Invoke-Executable {
		#/out=TestResult.txt
		Setup -File $(Join-Path $ProjectPath 'TestResult.txt')
		#/xml=TestResult.xml
		Setup -File $(Join-Path $ProjectPath 'TestResult.xml')	
	}
}

Fixture "Invoke-NUnit" {	

	Given "the Assembly and Project are both available" {		
	
		$expected = "MyProject.dll"
		$fake_project = @{
			PathToProjectFile = "MyProject.csproj"
			PathToAssembly = $expected
		}		
		Mock Get-Project {return $fake_project}		

		Then "it should prefer the Assembly" {			
			Invoke-NUnit
			
			Assert-MockCalled Invoke-Executable -Exactly 1 {$Parameters[0] -eq $expected}
		}	
	}
	
	Given "there's no Assembly present" {		
		$fake_project = @{
			PathToProjectFile = "MyProject.csproj"
		}		
		$expected = $fake_project.PathToProjectFile
		Mock Get-Project {return $fake_project}	

		Then "it should use the project file" {
			Invoke-NUnit
			
			Assert-MockCalled Invoke-Executable -Exactly 1 {$Parameters[0] -eq $expected}
		}
	}	

	Given "the path to nunit-console.exe is not set" {
		$_PathToNUnitConsoleExe = $tsr.PathToNUnitConsoleExe		
		Set-Properties @{PathToNUnitConsoleExe = $null}
		
		Mock Get-NUnitPackage {return @{Exe = $(Get-TestDriveItem $NUnitExePath).FullName}}
	
		Then "it should try to find the nuget package" {
			Invoke-NUnit
			
			Assert-MockCalled Get-NUnitPackage -Exactly 1
		}
		
		Set-Properties @{PathToNUnitConsoleExe = $_PathToNUnitConsoleExe}
	}
	
#	Given "the output is missing" {
#		Mock Get-FirstOrDefault {return $null} -parameterFilter {$Path -eq '.\TestResult.txt'}
#	
#		Then "it should display an error" {
#			Invoke-NUnit -ea SilentlyContinue -ev actual
#			
#			$actual | Should Be "NUnit output is missing"
#		}
#	}
#
#	Given "the report is missing" {
#		Mock Get-FirstOrDefault {return $null} -parameterFilter {$Path -eq '.\TestResult.xml'}
#
#		Then "it should display an error" {
#			Invoke-NUnit -ea SilentlyContinue -ev actual
#			
#			$actual | Should Be "NUnit report is missing"
#		}
#	}

	Given "we call nunit using categories" {
		$categories = @("Web","QA")
		$expected = "/include:$($categories -join '|')"
	
		Then "it should forward them to the nunit-console.exe call" {
			Invoke-NUnit $categories
			
			Assert-MockCalled Invoke-Executable -Exactly 1 {$Parameters[4] -eq $expected}
		}
	}
	
	
}
