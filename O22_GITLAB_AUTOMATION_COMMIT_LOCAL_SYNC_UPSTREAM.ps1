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

[String]$Scriptname="O22_GITLAB_AUTOMATION_COMMIT_LOCAL_SYNC_UPSTREAM.ps1"
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

$GitRepoROOT='G:\GITLAB_REPOS\'
$GitRepoName='gitlab_repo1'
#$param2 ="<FromPipeline>"
#$param3 ="<FromPipeline>"

#----------------------------------------------------

Try{
    $stopwatch.Start()
    $timestart=(Get-Date).ToString()
    AppendLog "Script $scriptname version $Scriptversion now executing @ $timestart in PowerShell version [$($PSVersionTable.PSVersion.ToString())] session in a [$([IntPtr]::Size * 8)] bit process"
    AppendLog "Running as user [$([Environment]::UserDomainName)\$([Environment]::UserName)] on host [$($env:COMPUTERNAME)]"
    
#--------------------------- Commit Local and check status----------------------------------------

Set-Location $GitRepoROOT
Appendlog "Changing Working directory to Local repo for local respository:  $GitRepoROOT"

$GitOutput = (git add -A 2>&1 )
Appendlog "Adding Untracked files to local respository:$GitOutput "

$GitOutput = (git commit  -m  "Commit Local Changes" 2>&1 )
Appendlog "Commited changes to local respository:$GitOutput "

$GitOutput = ( git status 2>&1 )
Appendlog "Git status of local respository :$GitOutput "

#----------------------- create Access token version of remote repos-----------------------
#------------------------remove any that exist 

#----------------------------------------Fetch Upstream ------------------------------------------------------
$GitRemote=git remote -v
foreach($grepo in $gitremote){If($grepo -match '(fetch)' -and $grepo -match $GitRepoName){$GitRemotefetch=$grepo}}

$GitOutput = (git fetch upstream 2>&1 )
Appendlog "Fetched Upstream data from $gitRemotefetch and synced to local respository :$GitOutput "

#----------------------------------------Push Upstream ------------------------------------------------------
$GitRemote=git remote -v 
foreach($grepo in $gitremote){If($grepo -match '(push)' -and $grepo -match $GitRepoName){$GitRemotePush=$grepo}}








$GitOutput = (git push -uf upstream main 2>&1)
Appendlog "Pushed Local repo to Upstream GitLab respository $GitRemotePush :$GitOutput "

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

cmd.exe /c 'cd "..\..\Program Files\Git\bin" && bash.exe -c "ssh-keygen -t rsa -b 4096 -C "blah@gmail.com" && eval $(ssh-agent -s) && ssh-add ~/.ssh/id_rsa && clip < ~/.ssh/id_rsa.pub && exit"' 
https://github.com/dahlbyk/posh-git


New-Alias -Name gitBash -Value $GitBashPath

$GitBashOutput += gitBash -c 'cd 'G:\GITLAB_REPOS\gitlab_repo1' && git remote -v && exit' 
#$GitBashOutput += gitBash -c "git remote -v"
#>