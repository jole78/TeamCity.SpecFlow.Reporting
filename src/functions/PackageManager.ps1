function Get-PackagesFolder {
	
	param(
		[string]$RootPath = (Get-Property 'PathToPackagesFolder')
	)
	
	$PackagesFolderPath = Join-Path $RootPath 'Packages'
	
	if(Test-Path -Path $PackagesFolderPath -PathType:Container) {
		$result = Get-Item $PackagesFolderPath
		return $result
	}
	
	throw "Failed to find the 'packages' folder at location: '$($PackagesFolderPath)'. Try using Set-Properties @{PathToPackagesFolder='[YOUR PATH]'}"
}

function Get-Package {
	param(
		[string]$Name = ''
	)
	
	$PackagesFolder = Get-PackagesFolder
	$results = Get-ChildItem $PackagesFolder | ?{$_.name -match "^$Name\.\d+"}
	
	if($results -eq $null) {
		throw "Failed to find a package with name '$Name' at location: $('$PackagesFolder.FullName')"
	}	
	
	$package = $results | Sort-Object -Property Name -Descending | Select-Object -First 1
	
	$result = @{
		Version = $package.Name -replace "$Name\."
	}
	
	return $result

}

