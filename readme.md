![](https://raw.github.com/wiki/jole78/TeamCity.SpecFlow.Reporting/images/logo.png) TeamCity.SpecFlow.Reporting
===

**TeamCity.Specflow.Reporting** is a low ceremony, convention over configuration, PowerShell module that automates the process of executing SpecFlow features via specflow.exe to produce a html report that can be shown in TeamCity.

It's distributed via [NuGet](https://nuget.org/packages/TeamCity.SpecFlow.Reporting) and requires minimal configuration in TeamCity.

It also, automatically, handles the error caused by .NET 4 or higher:

> "`The element <ParameterGroup> beneath element <UsingTask> is unrecognized.`"

...discussed [here](https://github.com/techtalk/SpecFlow/issues/232).


**TeamCity.Specflow.Reporting** is meant to be easy (ICI *Import-Customize(optional)-Invoke*)...but still highly customizable if you need it to be: 

```powershell
# 1. Import the module
Import-Module .\TeamCity.SpecFlow.Reporting.psm1

# 2. Invoke the report generation
Invoke-TeamCitySpecFlowReport
```

You can read more and get the details in the [wiki section.](https://github.com/jole78/TeamCity.SpecFlow.Reporting/wiki)
