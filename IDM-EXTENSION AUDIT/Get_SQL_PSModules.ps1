
#Install-Module -Name SqlServer -RequiredVersion 21.1.18256 

#Install-Package Microsoft.SqlServer.SqlManagementObjects #-Version 161.47008.0
#Get-PackageSource Microsoft.SqlServer.SqlManagementObjects


Get-Module -ListAvailable -Name SQLPS

<#
SQLSysClrTypes.msi – Microsoft System CLR Types for Microsoft SQL Server 2016
SharedManagementObjects.msi – Microsoft SQL Server 2016 Shared Management Objects
PowerShellTools.msi – Microsoft Windows PowerShell Extensions for Microsoft SQL Server 2016
#>

get-module -listAvailable


### TEST MODULES ###

 [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | out-null
 [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended") | Out-Null
 [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo") | Out-Null

 $SQLSserver ='dteksq2017-n1.dtek.com'

 $SMOserver = New-Object ('Microsoft.SqlServer.Management.Smo.Server') -argumentlist $SQLSserver



 ### check what assemblies i have 

 [appdomain]::CurrentDomain.GetAssemblies() |
Sort-Object -Property FullName |
Select-Object -Property FullName;

[AppDomain]::CurrentDomain.GetAssemblies() |
Where-Object FullName -like '*SMO*';



#This throwaway command in SqlServer module will autoload SQL assemmblies required

$null = Get-SqlAgent -ServerInstance 'dteksq2017-n1.dtek.com';