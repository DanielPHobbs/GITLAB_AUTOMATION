function Invoke-SQL {
    param(
        [string] $dataSource = ".\SQLEXPRESS",
        [string] $database = "MasterData",
        [string] $sqlCommand = $(throw "Please specify a query.")
      )

    $connectionString = "Data Source=$dataSource; " +
            "Integrated Security=SSPI; " +
            "Initial Catalog=$database"

    $connection = new-object system.data.SqlClient.SQLConnection($connectionString)
    $command = new-object system.data.sqlclient.sqlcommand($sqlCommand,$connection)
    $connection.Open()
    
    $adapter = New-Object System.Data.sqlclient.sqlDataAdapter $command
    $dataset = New-Object System.Data.DataSet
    $adapter.Fill($dataSet) | Out-Null
    
    $connection.Close()
    $dataSet.Tables

}



function Invoke-SqlSelect
{
    [CmdletBinding()]
    Param
    ( 
        [ValidateNotNullOrEmpty()] 
        [Parameter(ValueFromPipeline=$True,Mandatory=$True)] 
        [string] $SqlServer,
        [Parameter(ValueFromPipeline=$True,Mandatory=$False)] 
        [string] $Database = "master",
        [ValidateNotNullOrEmpty()] 
        [Parameter(ValueFromPipeline=$True,Mandatory=$True)] 
        [string] $SqlStatement
    )
    $ErrorActionPreference = "Stop"
    
    $sqlConnection = New-Object System.Data.SqlClient.SqlConnection
    $sqlConnection.ConnectionString = "Server=$SqlServer;Database=$Database;Integrated Security=True"
    
    $sqlCmd = New-Object System.Data.SqlClient.SqlCommand
    $sqlCmd.CommandText = $SqlStatement
    $sqlCmd.Connection = $sqlConnection
    
    $sqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
    $sqlAdapter.SelectCommand = $sqlCmd
    $dataTable = New-Object System.Data.DataTable
    try
    {
        $sqlConnection.Open()
        $sqlOutput = $sqlAdapter.Fill($dataTable)
        Write-Output -Verbose $sqlOutput
        $sqlConnection.Close()
        $sqlConnection.Dispose()
    }
    catch
    {
        Write-Output -Verbose "Error executing SQL on database [$Database] on server [$SqlServer]. Statement: `r`n$SqlStatement"
        return $null
    }
    

    if ($dataTable) { return ,$dataTable } else { return $null }
}