$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe "convention over configuration" {
	
	Context "when no values have been altered" {
		
		It "should use 'Release' configuration" {
			$cfg.Configuration | Should Be "Release"
		}
		
		It "should use the 'nunitexecution' report type" {
			$cfg.SpecFlowReportType | Should Be "nunitexecutionreport"
		}
	} 
}




