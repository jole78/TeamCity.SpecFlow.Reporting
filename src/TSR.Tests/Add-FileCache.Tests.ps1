###
. "$(Join-Path $PSScriptRoot '_TestContext.ps1')"
###


Fixture "Add-FileCache" {

	Given "there are 2 files to add to the cache" {
		Mock Set-Content {} {$Path -eq '.\files.generated'}
		
		$expected = "file1.txt;file2.txt" 
		$($expected -split ';') | % {$i = 1} {
			$key = $('File{0}' -f $i)
			$tsr.GeneratedFiles.$key = @{FullName = $_}
			$i++
		}
		
		Add-FileCache
			
		Then "we should add them all to the cache" {
			Assert-MockCalled Set-Content -Exactly 1 {$Value -eq $expected}
		} 
	}
}

