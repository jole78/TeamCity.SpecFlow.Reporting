###
. "$(Join-Path $PSScriptRoot '_TestContext.ps1')"
###

function Background {
	Mock Invoke-Executable {}
	Mock Get-FirstOrDefault {return @{}} {$Path -eq '.\TestResult.html'}
}

Fixture "Invoke-SpecFlow" {
	
	Given "get project fails" {
		Mock Get-Project {Write-Error "ERROR"}
		
		Then "we should stop executing" {
			{Invoke-SpecFlow} | Should Throw
		}
	}
	
	Given "the report doesn't exist after execution" {
		Mock Get-FirstOrDefault {return $null} {$Path -eq '.\TestResult.html'}

		Then "it should display an error" {
			Invoke-SpecFlow -ea:SilentlyContinue -ev actual
			
			$actual | Should Be "SpecFlow 'HtmlReport' output is missing"
		}
	}
	
	Given "the path to specflow.exe has not been set" {		
		Mock Get-SpecFlowPackage {return @{Exe = $(Get-TestDriveItem $SpecFlowExePath).FullName}}
		
		$_PathToSpecFlowExe = $tsr.PathToSpecFlowExe
		Set-Properties @{PathToSpecFlowExe = $null}
		
		Then "it should try to find the nuget package" {
			Invoke-SpecFlow
			
			Assert-MockCalled Get-SpecFlowPackage 1
		}
		
		Set-Properties @{PathToSpecFlowExe = $_PathToSpecFlowExe}
	}
	
	Given "the .NET version is 4 (or higher)" {	
		Setup -File $(Join-Path $ProjectPath 'specflow.exe.config')
		$file = Get-TestDriveItem $(Join-Path $ProjectPath 'specflow.exe.config')
		
		Mock Delete-File {}
		Mock Copy-Item {return @{FullName="TEST"}}
		
		Invoke-SpecFlow
		
		Then "we should copy the configuration file" {	
			Assert-MockCalled Copy-Item -Exactly 1 {$Path -eq $file.FullName}
		}
		
		And "remove the configuration file afterwards" {
			Assert-MockCalled Delete-File -Exactly 1 {$Path -eq "TEST"}
		}
	}
	
	Given "specflow.exe already has a configuration file" {
		Setup -File $(Join-Path $ProjectPath 'specflow.exe.config')
		$file = Get-TestDriveItem $(Join-Path $ProjectPath 'specflow.exe.config')
		Setup -File $(Join-Path $SpecFlowPath 'specflow.exe.config')
		
		Mock Copy-Item {}

		Then "we shouldn't try to copy the configuration file" {				
			Invoke-SpecFlow
			
			Assert-MockCalled Copy-Item -Exactly 0 {$Path -eq $file.FullName}		
		}
		
		# TODO: it would be nice if this could be more automatic (same with properties)
		#$tsr.GeneratedFiles = @{}
	}	
	
}


