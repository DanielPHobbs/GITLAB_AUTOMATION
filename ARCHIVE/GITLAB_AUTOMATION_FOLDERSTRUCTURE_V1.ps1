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
    { Write-output "$Placeholder already exists"}else{
    New-Item -Path $Placeholder  -ItemType file | out-null
    }
    }

    Function CodeFolders([String]$path){
        #------ Add a placeholder ----------
        $CodeFolder1 ="$path"+"\SQL_SCRIPTS"
        $CodeFolder2 ="$path"+"\RUNBOOK_EXPORTS"

    If (Test-Path -Path $CodeFolder1 -PathType Container)
    { Write-output "$CodeFolder1 already exists"}else{
        New-Item -Path $CodeFolder1  -ItemType Directory | out-null
        CreatePlaceholder $CodeFolder1 
        write-output  "Created Code Folder1 and Placeholder File in $CodeFolder1 "
    }
    If (Test-Path -Path $CodeFolder2 -PathType Container)
    { Write-output "$CodeFolder2 already exists"}else{
        New-Item -Path $CodeFolder2  -ItemType Directory | out-null
        CreatePlaceholder $CodeFolder2
        write-output  "Created Code Folder2 and Placeholder File in $CodeFolder2 "
        }
    }
#---------- Declarations ------------------------
[int]$folderLayer=''

#------------GET SQL DATA ------------------------

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

#$FolderStructure

#-------------------------------------------------------------------------------------

 [Array]$ROOT=@()
 [Array]$Layer1=@()
 [Array]$Layer2=@()
 [Array]$Layer3=@()

#--------Excludes JSON File-------------
$JSONExcludes="G:\VSCODE_WS01\GITLAB_AUTOMATION\Excludes.json"
$Excludes= Get-Content $JSONExcludes -Raw | Out-String
$folderExcludes= $Excludes | ConvertFrom-Json 
$folderExcludes=$folderExcludes | Select-Object -ExpandProperty path

Foreach ($folder in $folderStructure){

#----------Excludes -------------------
if($folder -notin $folderExcludes){    

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
    } else {write-output " Excluded Non Source Folder: $folder"}
}

#---------------------- Folder structure create -------------------
#--- ROOT First -----
$path = "G:\REPO_TEST"
Foreach($rPath in $root){
    $Rootpath = "$Path" + "$rPath"   
If (Test-Path -Path $Rootpath -PathType Container)
    { Write-output "$Rpath already exists"}
    ELSE
        { New-Item -Path $Rootpath  -ItemType directory | out-null
            Write-output "Created $Rootpath Folder in Repository"
        }
}
#--- LAYER1 with REPO folder Defaults -----

Foreach($L1Path in $layer1){
    $Layer1path = "$Path" + "$L1Path"   
If (Test-Path -Path $Layer1path -PathType Container)
    { Write-output "$Layer1path already exists"}
    ELSE
        { New-Item -Path $Layer1path  -ItemType directory | out-null
            Write-output "Created $Layer1path Folder in Repository"
            CodeFolders $Layer1path
        }
}