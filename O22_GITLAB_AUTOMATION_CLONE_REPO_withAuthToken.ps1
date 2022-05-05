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

$GitREPOLocPath ="G:\GITLAB_REPOS\"
$GitRemoteHTTPS ="https://gitlab.com/Dannyphobbs/gitlab_scorch_automation_IDMEXTENSIONrepo1.git"
$GitLabHeader   ="https://gitlab.com/Dannyphobbs/"
$TokenUname = 'GitLabAutomation_ORCH22'
$Token = "L1qwNRRMXnrtFhf6KPZ-"

#---------------------------------------------------------

Try{
    $stopwatch.Start()
    $timestart=(Get-Date).ToString()
    AppendLog "Script $scriptname version $Scriptversion now executing @ $timestart in PowerShell version [$($PSVersionTable.PSVersion.ToString())] session in a [$([IntPtr]::Size * 8)] bit process"
    AppendLog "Running as user [$([Environment]::UserDomainName)\$([Environment]::UserName)] on host [$($env:COMPUTERNAME)]"


#--------- Form GitLab Target and add auth PAT token

#----remove HTTPS://  
$GitLabRepoTail =$GitRemoteHTTPS -replace "HTTPS://" ,"" 
$GitLabRepoTail ="@" + "$GitLabRepoTail"
$AuthGitRemoteHTTPS ="https://" + "$TokenUname" + ":" + "$Token"+ "$GitLabRepoTail"

#-------------Clone Gitlab Repo-------------------------------

$DerivedPath = $GitRemoteHTTPS -replace $GitLabHeader ,"" 
$DerivedPath = $DerivedPath -replace ".{4}$"
$NewRepoPath = "$GitREPOLocPath" + "\" + "$DerivedPath"

Set-Location $GitREPOLocPath
AppendLog " Set location to  $GitREPOLocPath "

If (!(Test-Path -Path $NewRepoPath -PathType Container)){

$GitOutput = ( git clone $AuthGitRemoteHTTPS  2>&1 ) 

AppendLog " Cloning Gitlab Repo $GitRemoteHTTPS Git Cloning Result: $GitOutput "
}Else {
    AppendLog "Repo exists Cannot Clone Gitlab Repo $GitRemoteHTTPS "
}

#-------------------------------------------------------------
$DerivedPath = $GitRemoteHTTPS -replace $GitLabHeader ,"" 
$DerivedPath = $DerivedPath -replace ".{4}$"
$NewRepoPath = "$GitREPOLocPath" + "\" + "$DerivedPath"

If(Test-Path -Path $NewRepoPath ){Set-Location $NewRepoPath 
AppendLog " Set location to  $GitREPOLocPath "

$GitOutput = ( git status 2>&1 )
Appendlog "Git status of local respository :$GitOutput "


### ------------ delete and replace local repository registries as contain TOKEN, form new when needed----------

$GitRemote=git remote -v



$GitOutput = ( git remote -v 2>&1 )
Appendlog "Git Remote Repositories registered:  $GitOutput"




} else {Throw "Directory $NewRepoPath does not exist"}
# END
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




<#scratch

#-------------Create Local Folder from Gitlab Target------
$DerivedPath = $GitRemoteHTTPS -replace $GitLabHeader ,"" 
$DerivedPath = $DerivedPath -replace ".{4}$"
$DerivedPath
$LocRepoPath ="$GitREPOLocPath" + "$DerivedPath" 
$LocRepoPath
If (Test-Path -Path $LocRepoPath -PathType Container)
    { Appendlog "$LocRepoPath already exists,  Skipping Creation"}
    ELSE
        { New-Item -Path $LocRepoPath  -ItemType directory | out-null
            Appendlog "Created $LocRepoPath Folder in $GitREPOLocPath"

        }
#>