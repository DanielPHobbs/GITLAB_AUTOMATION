

$folder="\PRODUCTION"

[String]$JSONExcludes="G:\VSCODE_WS01\GITLAB_AUTOMATION\Excludes.json" 

$Excludes= Get-Content $JSONExcludes -Raw | Out-String
#$Excludes

$folderExcludes= $Excludes | ConvertFrom-Json 
#$folderExcludes

$folderExcludes=$folderExcludes | Select-Object -ExpandProperty path
$folderExcludes=$folderExcludes.replace(";", ",")


#------------TEST
clear-host


[String]$folder="\PRODUCTION"
[string]$folderexcludes1 = "\SCRATCH","\DEVELOPMENT","\PRODUCTION","\TEST","\UAT" 
#[string]$folderexcludes1 = "\PRODUCTION" 
#----------------
#$folderexcludes1

$folder -NotIn $folderExcludes1
$folderExcludes1 -NotContains $folder






if($folder -In $folderExcludes1){   
Write-output "Folder $folder created "
}

#"\PRODUCTION" -NotIn "\SCRATCH","\DEVELOPMENT","\PRODUCTION","\TEST","\UAT" 

#---HASHTABLE ---
$UserInput="\UAT1"
$validInputs = @{
    '\SCRATCH' = $true 
    '\DEVELOPMENT' = $true
    '\PRODUCTION' = $true
    '\TEST' = $true
    '\UAT' = $true
}
$validInputs

$FTest=$validInputs.ContainsKey($UserInput)
if(!$FTest){   
    Write-output "Folder $UserInput created "
    }else{    Write-output "Folder $UserInput skipped "
}




#--create hash from JSON 
$JSONExcludes="G:\VSCODE_WS01\GITLAB_AUTOMATION\Excludes.json" 
$Excludes= Get-Content $JSONExcludes -Raw | Out-String
$jsonObj = $Excludes | ConvertFrom-Json

$jsonObj




$UserInput="\TEST1"
$json = @'
{
  "Excludes": [
    {"\\PRODUCTION": "true"},
    {"\\UAT": "True"},
    {"\\DEVELOPMENT": "true"},
    {"\\SCRATCH": "true"},
    {"\\TEST": "true"}
  ]
}
'@

#-------------------- all good -----------------

$UserInput="\TEST"
$JSONExcludes="G:\VSCODE_WS01\GITLAB_AUTOMATION\Excludes.json" 

$FExcludesht = @{}
$Excludes= Get-Content $JSONExcludes -Raw | Out-String
ConvertFrom-Json $Excludes | Select-Object -Expand 'Excludes' | ForEach-Object {
    $FExcludesht[$_.PSObject.Properties.Name] = $_.PSObject.Properties.Value
}

$FTest=$FExcludesht.ContainsKey($UserInput)
if(!$FTest){   
    Write-output "Folder $UserInput created "
    }else{    Write-output "Folder $UserInput skipped "
}





$L1Path='\PRODUCTION\1.0 CONTRACT'

$l1root=Split-Path $L1Path
$l1root