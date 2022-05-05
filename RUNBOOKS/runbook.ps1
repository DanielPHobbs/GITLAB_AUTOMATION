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
Function CreatePlaceholder([String]$path){
#------ Add a placeholder ----------
$Placeholder ="$path"+"\Readme.txt"
New-Item -Path $Placeholder  -ItemType file | out-null
AppendLog  "Created Placeholder file  $Placeholder "

}

#------------- DECLARATIONS --------------------------

[String]$Scriptname="O22_GITLAB_AUTOMATION_CLONE_REPO.ps1"
[int]$Scriptversion=1.0
[string]$script:TraceLog=''
[string]$ResultStatus='Success'
[String]$trace=""
[String]$EMessage=""
[String]$ELine=""
[String]$ELNum=""
[String]$EInnermessage=""
[Array]$GitOutput=@()
$stopwatch=  [system.diagnostics.stopwatch]::New()

#------------- Define Pipeline Parameters Here ---------------

$GitREPOLocPath ='\`d.T.~Vb/{39CF4F54-B2CE-4A71-8664-D91997FAE58C}\`d.T.~Vb/'
$GitRemoteHTTPS ='\`d.T.~Vb/{54999268-2145-4151-98E1-F3EA73E1E3EB}\`d.T.~Vb/'
$GitLabHeader   ='\`d.T.~Vb/{CF98D9F6-C19D-4BE9-9248-486A1488F002}\`d.T.~Vb/'

#$param2 ="<FromPipeline>"
#$param3 ="<FromPipeline>"

#---------------------------------------------------------

Try{
    $stopwatch.Start()
    $timestart=(Get-Date).ToString()
    AppendLog "Script $scriptname version $Scriptversion now executing @ $timestart in PowerShell version [$($PSVersionTable.PSVersion.ToString())] session in a [$([IntPtr]::Size * 8)] bit process"
    AppendLog "Running as user [$([Environment]::UserDomainName)\$([Environment]::UserName)] on host [$($env:COMPUTERNAME)]"
    
#-------------Create Local Folder from Gitlab Target------
$DerivedPath = $GitRemoteHTTPS -replace $GitLabHeader ,"" 
$DerivedPath = $DerivedPath -replace ".{4}$"
$LocRepoPath ="$GitREPOLocPath" + "$DerivedPath" 
If (Test-Path -Path $LocRepoPath -PathType Container)
    { Appendlog "$LocRepoPath already exists,  Skipping Creation"}
    ELSE
        { New-Item -Path $LocRepoPath  -ItemType directory | out-null
            Appendlog "Created $LocRepoPath Folder in $GitREPOLocPath"

        }
#-------------Authenticate using PAT ------------------------
$user = 'gitlab+deploy-token-967155'
$token = 'esQJfqrgNiuwW54MXdcmG'

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$token)))

# -c http.extraHeader="Authorization: Basic $base64AuthInfo"

#-------------Clone Gitlab Repo-------------------------------
$NewRepoPath = "$LocRepoPath" + "\" + "$DerivedPath"
Set-Location $NewRepoPath
AppendLog " Set location to  $NewRepoPath "

If (!(Test-Path -Path $NewRepoPath -PathType Container)){
$GitOutput = ( git -c http.extraHeader="Authorization: Basic $base64AuthInfo" clone $GitRemoteHTTPS  2>&1 ) 
AppendLog " Cloning Gitlab Repo $GitRemoteHTTPS Git Cloning Result: $GitOutput "
}Else {
    AppendLog "Repo exists Cannot Clone Gitlab Repo $GitRemoteHTTPS "
}

#-------------------------------------------------------------

$GitOutput = ( git status 2>&1 )
Appendlog "Git status of local respository :$GitOutput "


$GitOutput = ( git remote -v 2>&1 )
Appendlog "Git Remote Repositories registered:  $GitOutput"

#
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

#$trace