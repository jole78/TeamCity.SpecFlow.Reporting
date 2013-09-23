###
. "$(Join-Path $PSScriptRoot '_TestContext.ps1')"
###


Fixture "Add-FileCache" {

	Given "the memory cache includes at least 1 item" {
		$expected = "file1.txt;file2.txt" -split ';'
		$expected | % {$i = 1} {
			$key = 'File{0}' -f $i
			$tsr.GeneratedFiles.$key = @{FullName = $_}
			$i++
		}
		
		Add-FileCache
		$file = $(Get-Content .\files.generated)
		$actual = $file -split ';'
			
		Then "that item should be included when the cache has persisted" {
			$actual.Count | Should Be $expected.Count
		} 
	}
}

