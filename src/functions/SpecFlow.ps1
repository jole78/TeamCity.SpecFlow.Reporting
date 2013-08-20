function Invoke-SpecFlow {
	
	$specflow = Get-SpecFlow
	
	if(Test-Path .\specflow.exe.config -PathType:Leaf) {
		$dir = (Get-Item $exe).Directory
		Copy-Item -Path .\specflow.exe.config -Destination $dir
				$out.SpecFlowExeConfig = ConvertToFileInfo (Get-Item (Join-Path $dir -ChildPath specflow.exe.config) | Select-Object -First 1)
			}
}

function Copy-SpecFlowConfigurationFile {

}

function Get-SpecFlow {
	# TODO: need support for multiple versions
		
	$root = Get-Package "specflow"

	$specflow_exe = Get-ChildItem $root.FullName -Include "specflow.exe" -Recurse | Select-Object -First 1
	if($specflow_exe -eq $null){
		throw "Failed to find specflow.exe in the packages folder: '$($packages.FullName)'"
	}	

	return @{
		SpecFlowExe = $specflow_exe.FullName
		HasConfigFile = Test-Path (Join-Path $specflow_exe.Directory 'specflow.exe.config') -PathType:Leaf
	}
}
