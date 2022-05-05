# Declare variables for connection and table to export
[string] $Server= "dteksq2017-n1"
[string] $Database = "orchestrator2022"
[string] $SqlQuery= @"
SELECT      
[Path] as path
FROM [Orchestrator2022].[Microsoft.SystemCenter.Orchestrator].[Folders]
FOR JSON AUTO
"@

# Declare Connection Variables
$SQLconnection = New-Object System.Data.SqlClient.SqlConnection
$SQLconnection.ConnectionString = "Integrated Security=SSPI;server=$Server;Database=$Database"

# Delcare SQL command variables
$SQLcommand = New-Object System.Data.SqlClient.SqlCommand 
$SQLcommand.CommandText = $SqlQuery
$SQLcommand.Connection = $SQLconnection 

# Load up the Tables in a dataset
$SQLAdapter = New-Object System.Data.SqlClient.SqlDataAdapter 
$SQLAdapter.SelectCommand = $SQLcommand 
$DataSet = New-Object System.Data.DataSet 
$null = $SqlAdapter.Fill($DataSet)
$SQLconnection.Close()

#----PROCESS RETURNED DATA -----Hide Header and adjust width--------
$folders =$DataSet.Tables[0] | Format-Table  -HideTableHeaders | out-string -Width 4096
$FolderStructure= $folders | ConvertFrom-Json
$FolderStructure=$FolderStructure | Select-Object -ExpandProperty path

$FolderStructure