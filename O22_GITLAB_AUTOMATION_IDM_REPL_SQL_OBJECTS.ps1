

#-----------------------------------------------
#   SCORCH 'Standard Powershell Activity Wrapper Template' 
#   Author: D.Hobbs
#   Date:   06/04/2022
#   Examples:
#
#-----------------------------------------------
# Disable this line for Production release
Set-StrictMode -Version 2


#---------------FUNCTIONS--------------------------------
function AppendLog ([string]$Message)
{
    $script:CurrentAction = $Message
    $script:TraceLog += ((Get-Date).ToString() + "`t" + $Message + " `r`n")
}

    
    

#------------- DECLARATIONS --------------------------

[String]$Scriptname="O22_GITLAB_AUTOMATION_IDM_REPL_SQL_OBJECTS.ps1"
[int]$Scriptversion=1.0
[string]$script:TraceLog=''
[string]$ResultStatus='Success'
[String]$trace=""
[String]$EMessage=""
[String]$ELine=""
[String]$ELNum=""
[String]$EInnermessage=""
[Array]$Objects=@()

$Objects.Clear()


$stopwatch=  [system.diagnostics.stopwatch]::New()



#------------- Define Pipeline Parameters Here ------

$SQLSserver= "dteksq2017-n1.dtek.com" 
$IDMDBName="IDM_EXTENSION" 
$SavePath = "E:\GITLAB_REPOS\gitlab_scorch_automation_IDMEXTENSIONrepo1"

#----------------------------------------------------

Try{
    $stopwatch.Start()
    $timestart=(Get-Date).ToString()
    AppendLog "Script $scriptname version $Scriptversion now executing @ $timestart in PowerShell version [$($PSVersionTable.PSVersion.ToString())] session in a [$([IntPtr]::Size * 8)] bit process"
    AppendLog "Running as user [$([Environment]::UserDomainName)\$([Environment]::UserName)] on host [$($env:COMPUTERNAME)]"
    AppendLog "Loading Required PS Modules and Assemblies"

    Install-Module -Name SqlServer
    
#--------------------------- Insert Required code Here ----------------------------------------
#Check DB exists and is online this will also  autoload SQL assemmblies required from  SqlServer module

Try{
$TargetDB = Get-SqlDatabase -name $IDMDBName -ServerInstance $SQLSserver -ea stop
}catch{ throw "Database $IDMDBName not found on SQL Server $SQLSserver.......Aborting!!!"}


$SMOserver = New-Object ('Microsoft.SqlServer.Management.Smo.Server') -argumentlist $SQLSserver

$db = $SMOserver.databases[$IDMDBName] 
    
    AppendLog "Adding User Tables Objects....continuing"
    IF($db.Tables){
    $Objects  = $db.Tables
    }else{AppendLog "The Database $IDMDBName has no User Tables....continuing"}
    
    AppendLog "Adding View Objects....continuing"
    IF($db.Views){
    $Objects += $db.Views
    }else{AppendLog "The Database $IDMDBName has no Views....continuing"}
    
    AppendLog "Adding Stored Procedure Objects....continuing"
    IF($db.StoredProcedures){
    $Objects += $db.StoredProcedures
    }else{AppendLog "The Database $IDMDBName has no Stored Procedures....continuing"}

    AppendLog "Adding User Defined Function Objects....continuing"
    IF($db.UserDefinedFunctions){
    $Objects += $db.UserDefinedFunctions
    }else{AppendLog "The Database $IDMDBName has no User Defined Functions....continuing"}

    
    #-------------------------- MAIN LOOP ----------------------
    [INT]$T=0;[INT]$v=0;[INT]$s=0;[INT]$f=0
    
    IF($objects){
    
    AppendLog "Setting SQL SMO Options"
    AppendLog "Creating SQL OBJECT Type Folder"
    AppendLog "Creating SQL OBJECT scripts"

    foreach ($SQLObject in $Objects | Where-Object {!($_.IsSystemObject)}) {
    
    $scriptr = new-object ('Microsoft.SqlServer.Management.Smo.Scripter') ($SMOserver)
    
    $scriptr.Options.AppendToFile = $False
    $scriptr.Options.AllowSystemObjects = $False
    $scriptr.Options.ClusteredIndexes = $True
    $scriptr.Options.DriAll = $True
    $scriptr.Options.ScriptDrops = $False
    $scriptr.Options.IncludeHeaders = $False
    $scriptr.Options.ToFileOnly = $True
    $scriptr.Options.Indexes = $True
    $scriptr.Options.Permissions = $True
    $scriptr.Options.WithDependencies = $False
    
    $TypeFolder=$SQLObject.GetType().Name

    if ((Test-Path -Path "$SavePath\$TypeFolder") -eq "true") { } 
    else {new-item -type directory -name "$TypeFolder"-path "$SavePath\"}
    
    $ScriptFile = $SQLObject -replace "\[|\]"
    $scriptr.Options.FileName = "$SavePath\$TypeFolder\$ScriptFile.SQL"
    
    
    $scriptr.Script($SQLObject)

    #----- counter -------
    If(($SQLObject.GetType().Name) -eq 'Table'){++$T}
    If(($SQLObject.GetType().Name) -eq 'View'){++$V}
    If(($SQLObject.GetType().Name) -eq 'StoredProcedure'){++$S}
    If(($SQLObject.GetType().Name) -eq 'UserDefinedFunction'){++$F}
    } 
        
    AppendLog "`n`r Added`n`r $t  :Tables`n`r $v  :Views`n`r $s  :StoredProcedures`n`r $F  :User Defined Functions `n`r"
    AppendLog "Completed SQL Object Processing for $IDMDBName"


    }Else{AppendLog "No SQL Objects to process.......Exiting"}


#----------------------------------------------------------------------------------------------


$ResultStatus = "Success"
$stopwatch.Stop()
$scripttime=$stopwatch.Elapsed.totalseconds

}
Catch{

    $ResultStatus = "Failed"

    $EMessage=$_.Exception.Message
    $ELine=$_.InvocationInfo.line
    $ELine=($ELine).Replace("`r`n","")
    $ELNum=$_.InvocationInfo.ScriptLineNumber
    $EInnermessage=$_.Exception.InnerException
    
    AppendLog  "!!!!!Exception In Script!!!!!"
    AppendLog  "Error Message  --  $EMessage "
    AppendLog  "Inner Error Message  --  $EInnermessage "
    AppendLog  "Err Command -- [$ELine] on Line $ELNum"
    

}finally{
    $stopwatch.Stop() 
    $scripttime=$stopwatch.Elapsed.totalseconds
    
        if($EMessage.Length -gt 0)
        {AppendLog "Exiting Powershell session with result [$ResultStatus] and error message [$EMessage], script runtime: $scripttime seconds @ $timestart"}
        else
        { AppendLog "Exiting Powershell session with result [$ResultStatus], script runtime: $scripttime seconds @ $timestart"}
        
        $trace=$script:TraceLog

        # ------------ Add Cleanups here -----------------
        $error.clear()

}

$trace

    
