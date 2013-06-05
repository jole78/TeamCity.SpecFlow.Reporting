

function Set-Properties {
	param(
		[HashTable]$properties
	)
	
	foreach ($key in $properties.keys) {
		$cfg[$key] = $properties.$key
    }
}

function Invoke-TeamCitySpecFlowReport {
	param(
	 [string[]]$categories = @()
	)
	
	try {
	
		$args = Parse-Arguments
		
		Invoke-NUnitConsoleExe $args.PathToAssemblyOrProject $categories
		Invoke-SpecFlowExe $args.PathToProjectFile | Tee-Object -Variable specflow_out | Out-Null
		
		Publish-Artifacts $specflow_out.HtmlReport
		Remove-Files $specflow_out
	
	} catch {
		Write-Error $_.Exception
		exit 1
	}
}

function Parse-Arguments {

	$args = @{}
	
	$proj = Get-ProjectInformation
	
	# Path to xxx.csproj
	if($cfg.PathToProjectFile) {
		if(Test-Path $cfg.PathToProjectFile -PathType:Leaf) {
		$args.PathToProjectFile = $cfg.PathToProjectFile
		} else { throw "Failed to find a project file at location '$($cfg.PathToProjectFile)'" }
	} else {
		$args.PathToProjectFile = $proj.PathToProjectFile
	}
	
	# Path to xxx.dll or xxx.csproj
	if($cfg.PathToAssemblyOrProject) {
		if(Test-Path $cfg.PathToAssemblyOrProject -PathType:Leaf) {
			$args.PathToAssemblyOrProject = $cfg.PathToAssemblyOrProject
		} else { throw "Failed to find an assembly or project file at location '$($cfg.PathToAssemblyOrProject)'" }
	} else {
		# Finds the dll in the 'bin' folder under the specified configuration [default: Release]
		$args.PathToAssemblyOrProject = Get-ChildItem -File -Recurse $proj.AssemblyName | Where-Object {
			($_.Directory.Parent.Name -eq "bin") -and ($_.Directory.Name -eq $cfg.Configuration)
		} | Select-Object -First 1
	}	

	return $args	
}

function Invoke-NUnitConsoleExe {
	param (
		[Parameter(Position = 0, Mandatory = 1)][string] $assemblyOrProject,
		[Parameter(Position = 1, Mandatory = 0)][string[]] $categories
	)
	
	# Path to nunit-console.exe
	if($cfg.PathToNUnitConsoleExe) {
		$exe = $cfg.PathToNUnitConsoleExe
	} else {
		$exe = Find-NUnitConsoleExe
	}
	
	if(Test-Path $exe -PathType:Leaf) {
		try {
			$parameters = @()
			
			$parameters += "$assemblyOrProject"
			$parameters += "/labels"
			$parameters += "/out=TestResult.txt"
			$parameters += "/xml=TestResult.xml"
			if($categories) {
				$parameters += "/include:$($categories -join ',')"
			}
			
			&$exe $parameters | Out-Null
		} catch {
			throw "Error when executing nunit-console.exe: " + $_
		}
	} else {
		throw "Failed to find 'nunit-console.exe' at location '$exe'"
	}
}

function Invoke-SpecFlowExe {
	param (
		[Parameter(Position = 1, Mandatory = 1)][string] $projectFile
	)
	
	$out = @{}
	
	# Output from NUnit
	if(Test-Path .\TestResult.txt -PathType:Leaf) {
		$out.NUnitOutput = Get-Item .\TestResult.txt
	} else {
		throw "Failed to find nunit output"
	}
	
	# Report from NUnit
	if(Test-Path .\TestResult.xml -PathType:Leaf) {
		$out.NUnitReport = Get-Item .\TestResult.xml
	} else {
		throw "Failed to find nunit report"
	}
	
	# Path to specflow.exe
	if($cfg.PathToSpecFlowExe) {
		$exe = $cfg.PathToSpecFlowExe
	} else {
		$exe = Find-SpecFlowExe
	}	
	
	if(Test-Path $exe -PathType:Leaf) {
		try {
			
			#copy config file if it exists
			if(Test-Path .\specflow.exe.config -PathType:Leaf) {
				$dir = (Get-Item $exe).Directory
				Copy-Item -Path .\specflow.exe.config -Destination $dir
				$out.SpecFlowExeConfig = Get-Item (Join-Path $dir -ChildPath specflow.exe.config)
			}
		
			$parameters = @()
			
			$parameters += $cfg.SpecFlowReportType
			$parameters += $projectFile
			
			&$exe $parameters | Out-Null
			
			if(Test-Path .\TestResult.html -PathType:Leaf) {
				$out.HtmlReport = Get-Item .\TestResult.html
			}
			
			return $out
			
		} catch {
			throw "Error when executing specflow.exe: " + $_
		} 
	} else {
		throw "Failed to find 'specflow.exe' at location '$exe'"
	}
}

function Get-PackagesFolder{
	$packages = Get-ChildItem -Directory -Path $cfg.PathToPackagesFolder packages
	if($packages -eq $null){
		throw "Failed to find the packages folder at location: '$($cfg.PathToPackagesFolder)'. Try using Set-Properties @{PathToPackagesFolder='[YOUR PATH]'}"
	}
	
	return $packages
}

function Get-ProjectInformation{
	$proj = Get-ChildItem -File "*.*proj" | Select-Object -First 1
	if($proj -eq $null){
		throw "Failed to find the project file (*.*proj)"
	}
	
	return @{
		PathToProjectFile = $proj.FullName
		AssemblyName = "$($proj.BaseName).dll"
	}
}

function Find-SpecFlowExe{
		
	$packages = Get-PackagesFolder
	#TODO: need to append the version like
	#SpecFlow.1.9.0
	
	$specflow_exe = Get-ChildItem -File -Recurse -Path $packages.FullName specflow.exe | Select-Object -First 1
	if($specflow_exe -eq $null){
		throw "Failed to find specflow.exe in the packages folder: '$($packages.FullName)'"
	}
	
	return $specflow_exe.FullName
}

function Find-NUnitConsoleExe{
		
	$packages = Get-PackagesFolder
	#TODO: need to append the version like
	#NUnit.Runners.2.6.2
	
	$nunit_console_exe = Get-ChildItem -File -Recurse -Path $packages.FullName nunit-console.exe | Select-Object -First 1
	if($nunit_console_exe -eq $null){
		throw "Failed to find nunit-console.exe in the packages folder: '$($packages.FullName)'"
	}
	
	return $nunit_console_exe.FullName
}

function Publish-Artifacts {
	param(
		[string]$path
	)
 if($cfg.PublishArtifacts) {
 	Write-Host "##teamcity[publishArtifacts '$path']"
 }
}

function Remove-Files {
	param(
		$files
	)
	
	if($cfg.Cleanup) {
	
		foreach($key in $files.Keys) {
			
			$file = $files[$key]
			if(Test-Path $file -PathType:Leaf) {
				Remove-Item $file -ErrorAction:SilentlyContinue | Out-Null
			}
		}	
	}
}


# default values
# override by Set-Properties @{Key=Value} outside of this script
$cfg = @{}
$cfg.Configuration = 'Release'
$cfg.SpecFlowReportType = 'nunitexecutionreport'
$cfg.PublishArtifacts = $true
$cfg.Cleanup = $true
$cfg.PathToPackagesFolder = '..\'

Export-ModuleMember -Function Invoke-TeamCitySpecFlowReport, Set-Properties

