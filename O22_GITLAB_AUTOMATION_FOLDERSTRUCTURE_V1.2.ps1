#-----------------------------------------------
#   SCORCH 'Orchestrator Folder Structure Sync to Repo' 
#   Author: D.Hobbs
#   Date:   06/04/2022
#   Examples:
#
#   TODO
#   1.  Check format of folder 
#   2.
#
#-----------------------------------------------
# Disable this line for Production release
#Set-StrictMode -Version 2

#-------------- FUNCTIONS -----------------------
function measure-occurrence {
    [CmdletBinding()]
    param (
      [string]$teststring
    )
   
    $teststring.ToCharArray() |
    Group-Object -NoElement |
    Sort-Object -Property Count -Descending
 
 }
Function CreatePlaceholder([String]$path){
    #------ Add a placeholder ----------
    $Placeholder ="$path"+"\Readme.txt"
    If (Test-Path -Path $Placeholder -PathType any)
    { Appendlog "$Placeholder already exists"}else{
    New-Item -Path $Placeholder  -ItemType file | out-null
    }
    }

Function CodeFolders([String]$path){
        #------ Add a placeholder ----------
        $CodeFolder1 ="$path"+"\SQL_SCRIPTS"
        $CodeFolder2 ="$path"+"\RUNBOOK_EXPORTS"

    If (Test-Path -Path $CodeFolder1 -PathType Container)
    { Appendlog "$CodeFolder1 already exists"}else{
        New-Item -Path $CodeFolder1  -ItemType Directory | out-null
        CreatePlaceholder $CodeFolder1 
        Appendlog  "Created Code Folder1 and Placeholder File in $CodeFolder1 "
    }
    If (Test-Path -Path $CodeFolder2 -PathType Container)
    { Appendlog "$CodeFolder2 already exists"}else{
        New-Item -Path $CodeFolder2  -ItemType Directory | out-null
        CreatePlaceholder $CodeFolder2
        Appendlog  "Created Code Folder2 and Placeholder File in $CodeFolder2 "
        }
    }
function AppendLog ([string]$Message)
    {
        $script:CurrentAction = $Message
        $script:TraceLog += ((Get-Date).ToString() + "`t" + $Message + " `r`n")
    }
#------------------------------------------------   
#---------- Declarations ------------------------
[int]$folderLayer=''
[String]$Scriptname="GITLAB_AUTOMATION_FOLDERSTRUCTURE_V1.2.ps1"
[int]$Scriptversion=1.2
[string]$script:TraceLog=''
[string]$ResultStatus='Success'
[String]$trace=""
[String]$EMessage=""
[String]$ELine=""
[String]$ELNum=""
[String]$EInnermessage=""
$stopwatch=  [system.diagnostics.stopwatch]::New()

#------------- Define Pipeline Parameters Here ------

[string]$path = "G:\GITLAB_REPOS\gitlab_repo1"                          # Path to Cloned Local Gitlab Repo
[String]$JSONExcludes="G:\VSCODE_WS01\GITLAB_AUTOMATION\Excludes.json"  # Path to JSON file for excluded SCORCH directories
[string] $Server= "dteksq2017-n1"                                       # Server containing SCORCH databse
[string] $Database = "orchestrator2022"                                 # SCORCH Database Name


#----------------------------------------------------

Try{
    $stopwatch.Start()
    $timestart=(Get-Date).ToString()
    AppendLog "Script $scriptname version $Scriptversion now executing @ $timestart in PowerShell version [$($PSVersionTable.PSVersion.ToString())] session in a [$([IntPtr]::Size * 8)] bit process"
    AppendLog "Running as user [$([Environment]::UserDomainName)\$([Environment]::UserName)] on host [$($env:COMPUTERNAME)]"
    
#--------------------------- Insert Required code Here ----------------------------------------

#------------GET SQL DATA ------------------------

# Declare variables for connection and table to export

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

#$FolderStructure

#-------------------------------------------------------------------------------------

 [Array]$ROOT=@()
 [Array]$Layer1=@()
 [Array]$Layer2=@()
 [Array]$Layer3=@()

#--------Excludes JSON File------------- TO-DO edit for multiple 
$FExcludesht = @{}
$Excludes= Get-Content $JSONExcludes -Raw | Out-String
ConvertFrom-Json $Excludes | Select-Object -Expand 'Excludes' | ForEach-Object {
    $FExcludesht[$_.PSObject.Properties.Name] = $_.PSObject.Properties.Value
}

  
#------------ MAIN FOLDER CREATION LOOP ------------
Foreach ($folder in $folderStructure){

#----------Excludes -------------------
$FTest=$FExcludesht.ContainsKey($folder)
if(!$FTest){    

 #---- Detect ROOTS and LAYERS---
 $count =measure-occurrence -teststring  $folder | Where-Object Name -eq '\'
 $folderLayer=$count.Count
 If($folderLayer -eq '1'){
    $ROOT += $folder
 }
 If($folderLayer -eq '2'){
    $Layer1+= $folder
 }
 If($folderLayer -eq '3'){ 
    $Layer2 += $folder

}
    } else {Appendlog " Excluded Non Source Root Folder: $folder"}
}

#---------------------- Folder structure create -------------------
#--- ROOT First -----

Foreach($rPath in $root){
    $Rootpath = "$Path" + "$rPath"   
If (Test-Path -Path $Rootpath -PathType Container)
    { Appendlog "$Rpath already exists"}
    ELSE
        { New-Item -Path $Rootpath  -ItemType directory | out-null
            Appendlog "Created  $Rootpath  Root Folder in Repository"
        }
}

Appendlog "Completed Root Folder structure Replication `n`r"




#--- LAYER1 with REPO folder Defaults -----
Appendlog "Starting Layer 1 Folder structure Replication `n`r"

Foreach($L1Path in $layer1){
   
$l1root=Split-Path $L1Path   
$FTest=$FExcludesht.ContainsKey($L1root)
     
if(!$FTest){

$Layer1path = "$Path" + "$L1Path"   
If (Test-Path -Path $Layer1path -PathType Container)
    { Appendlog "$Layer1path already exists"}
    ELSE
        { New-Item -Path $Layer1path  -ItemType directory | out-null
            Appendlog "Created $Layer1path Layer1 Folder in Repository"
            CodeFolders $Layer1path
        }
    }else {Appendlog " Skipped Layer1 as contained non source Root:$L1Path"}

}
Appendlog "Completed Layer1 Folder structure Replication `n`r"


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