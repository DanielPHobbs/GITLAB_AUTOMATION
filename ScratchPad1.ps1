$string = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
$measureObject = $string | Measure-Object -Character
$count = $measureObject.Characters
Write-output $count



$url = "http://sp13/sites/1/2/3"
$charCount = ($url.ToCharArray() | Where-Object {$_ -eq '/'} | Measure-Object).Count
Write-Host $charCount


function measure-occurrence {
    [CmdletBinding()]
    param (
      [string]$teststring
    )
   
    $teststring.ToCharArray() |
    Group-Object -NoElement |
    Sort-Object -Property Count -Descending
 
 }


measure-occurrence -teststring  'cwfhgfhcdsgfchgfegfegfkvcnfdhvjewy\dfsa' | where Name -eq 's'


<#--------FolderStructure JSON File -------------
$JSON ="G:\VSCODE_WS01\GITLAB_AUTOMATION\FolderStructure.json"
$FolderJSON = get-content $JSON -raw | Out-String
$folderStructure= $FolderJSON | ConvertFrom-Json 
#>


