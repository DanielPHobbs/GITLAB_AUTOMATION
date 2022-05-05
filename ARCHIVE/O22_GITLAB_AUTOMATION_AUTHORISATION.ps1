#--------------Create credentials------------------------------------------
<#
$MyPat = "esQJfqrgNiuwW54MXdcG"

$UserName = "gitlab+deploy-token-967155"

$B64Pat = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("$UserName:$MyPat"))



#-------------- Use credentials example
git -c http.extraHeader="Authorization: Basic $B64Pat" clone https://dev.azure.com/yourOrgName/yourProjectName/_git/yourRepoName

#-------------this is the auth header insert ---------------------------------
http.extraHeader="Authorization: Basic $B64Pat"
#>


###----- this seems better 

Set-Location "G:\GITLAB_REPOS\gitlab_scorch_automation_IDMEXTENSIONrepo1\gitlab_scorch_automation_IDMEXTENSIONrepo1"

$user = 'gitlab+deploy-token-967155'
$token = "esQJfqrgNiuwW54MXdcmG"

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$token)))

git -c http.extraHeader="Authorization: Basic $base64AuthInfo" status "https://gitlab.com/Dannyphobbs/gitlab_scorch_automation_IDMEXTENSIONrepo1.git"
