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

[String]$Scriptname="SCORCH_PS_Wrapper_64.ps1"
[int]$Scriptversion=1.1
[string]$script:TraceLog=''
[string]$ResultStatus='Success'
[String]$trace=""
[String]$EMessage=""
[String]$ELine=""
[String]$ELNum=""
[String]$EInnermessage=""
$stopwatch=  [system.diagnostics.stopwatch]::New()

#------------- Define Pipeline Parameters Here ------

$DropFolder = '\\GITLAB_AUTOMATION\Filedrop'
$TargetFolder = 'G:\GITLAB_AUTOMATION\TargetFolder' # this will be REPO when live 


#----------------------------------------------------

Try{
    $stopwatch.Start()
    $timestart=(Get-Date).ToString()
    AppendLog "Script $scriptname version $Scriptversion now executing @ $timestart in PowerShell version [$($PSVersionTable.PSVersion.ToString())] session in a [$([IntPtr]::Size * 8)] bit process"
    AppendLog "Running as user [$([Environment]::UserDomainName)\$([Environment]::UserName)] on host [$($env:COMPUTERNAME)]"
    
#--------------------------- Insert Required code Here ----------------------------------------
#---- File Constants -----
$RBEXP='RUNBOOK_EXPORTS'
$SQLEXP='SQL_SCRIPTS'
$Prod='PRODUCTION'
$Dev='DEVELOPMENT'

#------------------- TESTING AREA ----------------------
$Testfile1="2.0_RB1_SQL1_SP2.sql"

$files = Get-ChildItem $DropFolder -ea stop| Where-Object {$_.PSIsContainer -eq $False} 
ForEach ($file in $files) {
#Regex format checker and rejector[append 'incorrect_format']
if ($file -cmatch '\.[^.]+$') {
    $FExtension = $matches[0]
}

If ($FExtension -eq '.ois_export'){
    [regex]$regex='^\d{1}\.\d{1}_[a-zA-Z0-9]{1,10}_[a-zA-Z0-9]{1,10}_[a-zA-Z0-9]{1,10}\.ois_export'}
ElseiF ($FExtension -eq '.sql'){
    [regex]$regex='^\d{1}\.\d{1}_[a-zA-Z0-9]{1,10}_[a-zA-Z0-9]{1,10}_[a-zA-Z0-9]{1,10}\.sql'}
Else{    AppendLog "No Files to Process...Exiting"
        Break
}


If (($regex.match($file)).Success -eq $True) {
    AppendLog "File Name $file is in correct format....Processing"

    } else {
            #--------rename adding --!!!Incorrectly-named-File!!!
            $newname = "!!!Incorrectly-named-File!!!---" + "$file" 
            
            If($file -NotLike '*Incorrectly-named-File*'){
            AppendLog "File Name $file is in incorrect format....renaming"   
            Rename-Item $file.fullname -NewName $newname
}
    }

    #Get file extension [SQL,OIS]
    if ($file -cmatch '\.[^.]+$') {
        $FExtension = $matches[0]
      }
      AppendLog "File Name extension is $fExtension....extracting"

#get first characters as Index [2.0] 
$Index=[Regex]::Match($file,'.{1,3}').Value
If ($index -notlike '!!!'){
AppendLog "File Index is $index....extracting"
}



#Get Name of solution '_TEXT_TEXT_TEXT' [remove _]
$SolName=''


#form folder name
$RB_TargetFolder=''
$SQ_TargetFolder=''

#--------is there a folder called $RB_TargetFolder or $SQ_TargetFolder



#-------Mover



}


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