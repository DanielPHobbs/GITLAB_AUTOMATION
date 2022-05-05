
function ExecuteSqlQuery ($Server, $Database, $SQLQuery) {
    $Datatable = New-Object System.Data.DataTable
    
    $Connection = New-Object System.Data.SQLClient.SQLConnection
    $Connection.ConnectionString = "server='$Server';database='$Database';trusted_connection=true;"
    $Connection.Open()
    $Command = New-Object System.Data.SQLClient.SQLCommand
    $Command.Connection = $Connection
    $Command.CommandText = $SQLQuery
    $Reader = $Command.ExecuteReader()
    $Datatable.Load($Reader)
    $Connection.Close()
    
    return $Datatable
    
}

[string] $Server= "dteksq2017-n1"
[string] $Database = "orchestrator2022"
[string] $SqlQuery= @"
SELECT      
[Path] as path
FROM [Orchestrator2022].[Microsoft.SystemCenter.Orchestrator].[Folders]
FOR JSON AUTO
"@

$resultsDataTable = New-Object System.Data.DataTable
$resultsDataTable = ExecuteSqlQuery $Server $Database $SqlQuery 
#$JSON = $resultsDataTable | Format-Table  -HideTableHeaders

#$JSON |out-file 'g:\temp\json.json'
#$JSON
$resultsDataTable